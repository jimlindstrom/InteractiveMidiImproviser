  task :test do
    sh "rspec -c -I '.' specs/"
  end

  task :miditest do
    system "if `lsmod | grep virmidi > /dev/null 2>&1` ; then echo 'Virtual Raw Midi devices are present'; else echo 'Virtual Raw Midi devices are NOT present.  Try running: sudo modprobe snd-virmidi index=1'; fi"
  end