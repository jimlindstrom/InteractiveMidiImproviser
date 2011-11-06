#!/usr/bin/env ruby

require 'observer'
require 'statemachine'
require 'thread'
require 'midi/event_queue'

module Listen
  
  # this class is a member of the statemachine
  class MachineContext
        include Observable

    attr_accessor :time_of_last_event, :timeout_flag, :mutex
  
    def initialize
      @event_queue = Midi::EventQueue.new
      @time_of_last_event = Time.now
      @mutex = Mutex.new
      @response_lambda = nil
    end
    
    # this allows the context to access the machine (its owner)
    def set_machine(machine)
      @machine = machine
    end

    # this allows the context to access an outside implementation of generate_response
    def set_response_lambda(response_lambda)
      @response_lambda = response_lambda
    end
  
    def reset
      clear_queue
      clear_timeout_flag
    end
  
    def clear_queue
      @event_queue.clear
    end
  
    def clear_timeout_flag
      @mutex.synchronize do
        @timeout_flag = false
        @time_of_last_event = Time.now
      end
    end
  
    def enqueue_event(e)
      @event_queue.enqueue(e)
      @time_of_last_event = Time.now
      set_timeout
    end
  
    def set_timeout
      if @machine.nil?
        raise RuntimeError.new("cannot set timeout because machine is nil")
      end

      Thread.new do
        sleep 2
        secs_since_last_event = (Time.now - @time_of_last_event)
        if secs_since_last_event > 1.9
          @mutex.synchronize do
            if @timeout_flag == false
              @timeout_flag = true
              @machine.timeout
            end
          end
        end
      end
    end
  
    def respond
      changed
      notify_observers(@event_queue)

      # NOTE: observer must call '@machine.response_done' afterwards
    end
  
    def show_response_done
    end
  end
  
  def Listen::create_listener_machine
    listener_machine = Statemachine.build do
      state :wait_for_stimulus_start do
        event :midievent, :wait_for_stimulus_end, :enqueue_event
        on_entry :reset
    
        event :timeout, :wait_for_stimulus_start # ignore timeouts in this state
      end
    
      state :wait_for_stimulus_end do
        event :midievent, :wait_for_stimulus_end, :enqueue_event
        event :timeout, :do_response, :respond
      end
    
      state :do_response do
        event :response_done, :wait_for_stimulus_start, :show_response_done
    
        event :timeout, :do_response # ignore timeouts in this state
        event :midievent, :do_response #ignore midievents in this state
      end
    
      context MachineContext.new
    end
  
    listener_machine.context.set_machine(listener_machine)
  
    return listener_machine
  end
  
end
