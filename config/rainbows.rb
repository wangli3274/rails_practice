#	rainbows config
Rainbows! do
  use :EventMachine
  worker_connections 1024  # 每个进程创建多少个线程
end

# paths and things
app_path = File.join(File.dirname(__FILE__), '..')
puts app_path
log_path = File.join(app_path, 'log')

FileUtils.mkdir_p log_path

socket_path = File.join(app_path, 'tmp/sockets/rainbows.sock')
pid_path    = File.join(app_path, 'tmp/pids/rainbows.pid')
err_path    = File.join(log_path, 'rainbows.error.log')
out_path    = File.join(log_path, 'rainbows.out.log')

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 4

# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# tell it where to be
working_directory app_path

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen 7430  #, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
pid pid_path

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path err_path
stdout_path out_path

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

# This loads the app in master, and then forks workers. Kill with USR2 and it will do a graceful restart using the block proceeding.
preload_app true

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  puts old_pid

  if File.exists?(old_pid) && old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end

