#!/usr/bin/env ruby

module Midi

  class Event

    attr_accessor :message, :pitch, :velocity, :timestamp

    # message type constants
    NOTE_ON  = 144
    NOTE_OFF = 128

    def initialize(opts)
      return if opts.nil?
      raise ArgumentError if (opts.keys-[:message,:pitch,:velocity,:timestamp]) != []
      @message   = opts[:message]   if !opts[:message].nil?
      @pitch     = opts[:pitch]     if !opts[:pitch].nil?
      @velocity  = opts[:velocity]  if !opts[:velocity].nil?
      @timestamp = opts[:timestamp] if !opts[:timestamp].nil?
    end

  end

end
