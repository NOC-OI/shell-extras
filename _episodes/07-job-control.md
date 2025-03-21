---
title: Processes and Job Control
teaching: 20
exercises: 10
questions:
- "How do keep track of the process running on my machine?"
- "Can I run more than one program/script from within a shell?"
objectives:
- "Learn how to use `ps` to get information about the state of processes"
- "Learn how to control, ie., \"stop/pause/background/foreground\" processes"
keypoints:
- "When we talk of 'job control', we really mean 'process control'"
- "A running process can be stopped, paused, and/or made to run in the background"
- "A process can be started so as to immediately run in the background"
- "Paused or backgrounded processes can be brought back into the foreground"
- "Process information can be inspected with `ps`"
- "The `top` (or `htop`) command shows a live view of the resouces used by each process."
- "The `tmux` command allows us to leave a command running and disconnect from the system by press Ctrl+B d."
- "The `tmux` session can be reattached with `tmux -a`."
---

With her two days worth of data Nelle now has over 1500 files to process and
this is going to take her a while. She would like to monitor what is running
and to be able to work on some other things while this runs in the background.

# Job Control

We'll now take a look at how to control programs *once they're running*. This
is called [job control]({ page.root }}/reference/{{ site.index }}#job-control).

When we talk about controlling programs, what we really mean is
controlling *processes*. A process is just a program
that's in memory and executing. Some of the processes on your computer
are yours: they're running programs you explicitly asked for, like
Nelle's `do-stats` script. Many others belong to the operating system that
manages your computer for you, or, if you're on a shared machine, to other
users.

## The `ps` command

You can use the `ps` command to list processes, just as you use `ls`
to list files and directories.

> ## Behaviour of the `ps` command
>
> The `ps` command has a swathe of option flags that control
> its behaviour and, what's more, the sets of flags and default
> behaviour vary across different platforms.
>
> A bare invocation of `ps` only shows you basic information about
> *your*, *active* processes.
>
> After that, this is a command that it is worth reading the
> '`man` page' for.
>
{: .callout}

~~~
$ ps
~~~
{: .language-bash}
~~~
  PID TTY          TIME CMD
12767 pts/0    00:00:00 bash
15283 pts/0    00:00:00 ps
~~~
{: .output}

At the time you ran the `ps` command, you had
two active processes, your  (`bash`) shell and the  (`ps`) command
you had invoked in it.

Chances are that you were aware of that information, without needing
to run a command to tell you it, so let's try and put some flesh on
that bare bones information.

~~~
$ ps -f
~~~
{: .language-bash}
~~~
UID        PID  PPID  C STIME TTY          TIME CMD
nelle     12396 25397  0 14:28 pts/0    00:00:00 ps -f
nelle    25397 25396  0 12:49 pts/0    00:01:39 bash
~~~
{: .output}

In case you haven't had time to do a `man ps` yet, be aware that
the `-f` flag doesn't stand for "flesh on the bones" but for
"Do full-format listing", although even then, there are "fuller"
versions of the `ps` output.

### What is `ps` telling us?

Every process has a unique process id (PID). Remember, this is a
property of the process, not of the program that process is executing:
if you are running three instances of your browser at once, each will
have its own process ID.

The third column in this listing, PPID, shows the ID of each process's
parent. Every process on a computer is spawned by another, which is its
parent (except, of course, for the bootstrap process that runs
automatically when the computer starts up).

Clearly, the `ps -f` that was run is a child process of the (`bash`)
shell it was invoked in.

Column 1 shows the username of the user the processes
are being run by. This is the username the computer uses when checking
permissions: each process is allowed to access exactly the same things as
the user running it, no more, no less.

Column 5, STIME, shows when the process started running, whilst Column 7,
TIME, shows you how much time process has used, whilst Column 8,
CMD, shows what program the process is executing.

Column 6, TTY, shows
the ID of the terminal this process is running in. Once upon a time,
this really would have been a terminal connected to a central timeshared
computer. It isn't as important these days, except that if a process is
a system service, such as a network monitor, `ps` will display a
question mark for its terminal, since it doesn't actually have one.

The fourth column, C, is an indication of the perCentage of processor
utilization.

Your version of `ps` may
show more or fewer columns, or may show them in a different order, but
the same information is generally available everywhere, and the column
headers are generally consistent.

## Stopping, pausing, resuming, and backgrounding, processes

The shell provides several commands for stopping, pausing, and resuming
processes. To see them in action, let's run our `do-stats.sh` script on our
latest data files. After a few minutes go by, we realize that this is
going to take a while to finish. Being impatient, we kill the process by
pressing the Control and C keys at the same time. This stops the
currently-executing program right away. Any results it had calculated, but not
written to disk, are lost.

~~~
cd north-pacific-gyre
./do-stats.sh 2012-07-03/NENE*txt
~~~
{: .language-bash}

~~~
...a few minutes pass...
^C
~~~
{: .output}

Let's run that same command again, with an ampersand `&` at the end of
the line to tell the shell we want it to run in the
[background]({{ page.root }}/reference/{{ site.index }}#background):

~~~
./do-stats.sh 2012-07-03/NENE*txt &
~~~
{: .language-bash}

When we do this, the shell launches the program as before. Instead of
leaving our keyboard and screen connected to the program's standard
input and output, though, the shell hangs onto them. But any output
will still appear on screen, which depending on how frequent it is can be quite
annoying or quite useful. This means the shell can give us a fresh command
prompt, and start running other commands, right away. For example we can run
the `ls` command in the `2012-07-03` directory to see how many of the results
(.stats) files have been created.

~~~
ls 2012-07-03
~~~
{: .language-bash}

Now let's run the `jobs` command, which tells us what processes are currently
running in the background:

~~~
$ jobs
~~~
{: .language-bash}

~~~
[1]+  Running                 ./do-stats.sh 2012-07-03/NENE*txt &
~~~
{: .output}

Since we're about to go and get coffee, we might as well use the
foreground command, `fg`, to bring our background job into the
foreground:

~~~
$ fg
~~~
{: .language-bash}

~~~
...a few minutes pass...
~~~
{: .output}

When `do-stats.sh` finishes running, the shell will give us a fresh prompt as
usual. If we had several jobs running in the background, we could
control which one we brought to the foreground using `fg %1`, `fg %2`,
and so on. The IDs are *not* the process IDs. Instead, they are the job
IDs displayed by the `jobs` command.

The shell gives us one more tool for job control: if a process is
already running in the foreground, Control-Z will pause it and return
control to the shell. We can then use `fg` to resume it in the
foreground, or `bg` to resume it as a background job. For example, let's
run `do-stats.sh` again, and then type Control-Z. The shell immediately
tells us that our program has been stopped, and gives us its job number:

~~~
./do-stats.sh 2012-07-03/NENE*txt
^Z
~~~
{: .language-bash}

~~~
[1]+  Stopped   ./do-stats.sh 2012-07-03/NENE*txt
~~~
{: .output}

If we type `bg %1`, the shell starts the process running again, but in
the background. We can check that it's running using `jobs`, and kill it
while it's still in the background using `kill` and the job number. This
has the same effect as bringing it to the foreground and then typing
Control-C:

~~~
$ bg %1

$ jobs
~~~
{: .language-bash}

~~~
[1]+  Running                ./do-stats.sh 2012-07-03/NENE*txt &
~~~
{: .output}
~~~
$ kill %1
~~~
{: .language-bash}

Job control was important when users only had one terminal window at a
time. It's less important now: if we want to run another program, it's
easy enough to open another window and run it there. However, these
ideas and tools are making a comeback, as they're often the easiest way
to run and control programs on remote computers elsewhere on the
network. This lesson's [ssh episode]({{ page.root }}/02-ssh/{{ site.index }})
has more to say about that.

### Killing by process ID

The `kill` command can also take a process ID that we can discover using the
`ps` command. Let's launch our `do-stats.sh` process again, background it
and discover it's process ID.

~~~
./do-stats.sh 2012-07-03/NENE*.txt &
ps -f
~~~
{: .language-bash}

~~~
UID          PID    PPID  C STIME TTY          TIME CMD
nelle    1551177   15724  0 Mar14 pts/11   00:00:01 /bin/bash
nelle    1982690 1551177  0 00:28 pts/11   00:00:00 bash ./do-stats.sh 2012-07-03/NENE01729A.txt 2012-07-03/NENE01729B.txt 2012-07-03/NENE01736A.txt 2012-07-03/NENE01751A.txt 
nelle    1982694 1982690  0 00:28 pts/11   00:00:00 bash goostats 2012-07-03/NENE01729A.txt 2012-07-03/NENE01729A.txt.stats
nelle    1982698 1982694  0 00:28 pts/11   00:00:00 sleep 2
nelle    1982702 1551177  0 00:28 pts/11   00:00:00 ps -f
~~~
{: .output}

We can see several processes in the list now, the first one 
(`bash ./do-stats.sh`) is the one we started from the command line. We can tell
this because it's PPID is our `bash` processes that is giving the command
prompt. The third one is the `goostats` process launched by `do-stats.sh`
and the fourth is a `sleep` process (which just waits the specified number of
seconds) that is used by `goostats`. If we want to stop the whole pipeline
then we want to kill the `do-stats.sh` process, which in the above output
has the PID 1982690. We can give this PID to the `kill` command.

~~~
kill 1982690
~~~
{: .langauge-bash}

### Killing by process name

Instead of looking up the process name we can also kill a process by it's name
using the `killall` command. As the name suggests, this will match all processes
with the specified name. In our case `killall do-stats.sh` will stop our
pipeline. We need to be careful with `killall`, running `killall bash` would
kill every `bash` process on our system (at least owned by the current user),
if we had several terminals open they would all be killed by this.


## Tmux: A more advanced way to background processes 

A more advanced way to background processes is to use the `tmux` command.
This allows us to detach completely from the process, keep it running in the
background and capture it's output in a way that we can get back to it.
Unlike using `&` or `bg` it doesn't put any output onto our terminal when we
are detached. If we are running a process on a remote system using SSH then
it can also keep running once we logout and close our SSH connection, this 
does not happen when backgrounding a process and (eventually) the process will
stop as the SSH session is a parent process of the bash process which launched
the command and when we exit the SSH session all of it's child processes are 
killed.

### Launching Tmux

To launch a `tmux` session simply type:

~~~
tmux
~~~
{: .language-bash}

Note that `tmux` is not always installed on every system and you might need to
install it or ask your system administrator to do so.

When `tmux` launches it will clear the screen and a bar with the name of the
current process, the username, hostname, time and date will appear at the bottom.
We can now start a process such as our pipeline inside `tmux`:

~~~
./do-stats.sh 2012-07-03/NENE*.txt
~~~
{: .langauge-bash}

We can now disconnect from our `tmux` session by pressing the
Control and B keys and then pressing the d key (for disconnect). Our process is
left running inside `tmux` but none of the output is display on the screen.

### Reconnecting Tmux

To reconnect to `tmux` we need to run it with the `-a` option.

~~~
tmux -a
~~~
{: .language-bash}

### Exiting Tmux

To end a `tmux` session we use the `exit` command to close down `tmux`
completely.

### Screen - An alternative to Tmux

GNU Screen is a similar program to `tmux` that has the same basic functionality
. Some older systems might have `screen` installed instead of `tmux`. The basic
keys are the same, except you press Control and A instead of Control and B. The
command to reattach is `screen -r` instead of `tmux -d`.

## Top - A more advanced way to monitor processes

The `ps` command is very useful for monitoring what processes are runnning, 
but sometimes we have situations that are rapidly changing and by the time
we've typed `ps` the process we are interested in has exited. The `top`
command is like running `ps` continuously. It also supports sorting the
process list by a number of attributes including how much CPU time or memory a
process is using. This can be very useful when trying to find which process(es)
are using the most resources. To launch `top`, simply run the command:

~~~
top
~~~
{: .language-bash}

Which field we are sorting by can be controlled by pressing the `>` or `<` keys
. To exit press the "q" key.

### Htop - a nicer version of top

A newer and easier to use version of `top` is called `htop`. This uses the
"F" keys on your keyboard to operate it and is a bit more intuitive than `top`.
`htop` is not always installed by default and your might need to install it or
ask your system administrator to install it.


> ## Find the PID of tmux
> Start a `tmux` session and then disconnect from it by pressing control b
> and then pressing d. Now use `ps` to find out the PID of your `tmux`.
> You will need some extra options you haven't used before. Hint: the correct
> option might return a lot of processes, you can filter this by piping the
> output to the `grep tmux` command.
> 
> > ## Solution
> > ~~~
> > ps -A | grep tmux
> > ~~~
> > {: .language-bash}
> > or
> > ~~~
> > ps -aux | grep tmux
> > ~~~
> > {: .language-bash}
> >
> {: .solution}
{: .challenge}

> ## Monitor Nelle's Pipeline with (h)top
> Inside a `tmux` session start running Nelle's pipeline with the `do-stats.sh`
> script on the bigger `2012-07-04` dataset. Disconnect from the `tmux` session
> and use `top` or `htop` to monitor the progress. 
> Is `goostats` using much CPU time?
> Would you expect it to be?
> Have a look at the contents of the `goostats` program (it is a shell script)
> what is taking most of the time? How much CPU time should that operation use?
> 
> > ## Solution
> > `goostats` isn't really doing very much, it spends most of it's time
> > sleeping, which doesn't use much CPU activity. So it won't be showing much
> > CPU time and won't be at the top of `top`'s list of processes. 
> >
> {: .solution}
{: .challenge}

> ## Monitoring other processes with (h)top or ps
> If you have SSH access to some kind of shared server connect to this server 
> and run `top`, `htop` or `ps aux` on there and have a look at which processes
> are using the most CPU or memory resources. What is the process name? 
> Which user does that process belong to?
{: .challenge}


{% include links.md %}
