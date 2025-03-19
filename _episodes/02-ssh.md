---
title: "Working Remotely"
teaching: 20
exercises: 15
questions:
- "How do I use '`ssh`' and '`scp`' ?"
objectives:
- "Learn what SSH is"
- "Learn what an SSH key is"
- "Generate your own SSH key pair"
- "Learn how to use your SSH key"
- "Learn how to work remotely using `ssh` and `scp`"
- "Add your SSH key to an remote server"
keypoints:
- "SSH is a secure alternative to username/password authorization"
- "SSH keys are generated in public/private pairs. Your public key can be shared with others. The private keys stays on your machine only."
- "The 'ssh' and 'scp' utilities are secure alternatives to logging into, and copying files to/from remote machine"
---
Let's take a closer look at what happens when we use the shell
on a desktop or laptop computer.
The first step is to log in
so that the operating system knows who we are and what we're allowed to do.
We do this by typing our username and password;
the operating system checks those values against its records,
and if they match,
runs a shell for us.

As we type commands,
the 1's and 0's that represent the characters we're typing are sent from the keyboard to the shell.
The shell displays those characters on the screen to represent what we type,
and then,
if what we typed was a command,
the shell executes it and displays its output (if any).

What if we want to run some commands on another machine,
such as the server in the basement that manages our database of experimental results?
To do this,
we have to first log in to that machine.
We call this a [remote login]({{ page.root }}/reference/{{ site.index }}#remote-login).

In order for us to be able to login, the remote computer must be running
a [remote login server]({{ page.root }}/reference/{{ site.index }}#remote-login-server) and we will
run a client program that can talk to that server.
The client program passes our login credentials to the remote login server
and, if we are allowed to login, that server then runs a shell for us on the
remote computer.

Once our local client is connected to the remote server,
everything we type into the client is passed on, by the server, to the shell
running on the remote computer.
That remote shell runs those commands on our behalf,
just as a local shell would,
then sends back output, via the server, to our client, for our computer to display.

## SSH History

Back in the day,
when everyone trusted each other and knew every chip in their computer by its first name,
people didn't encrypt anything except the most sensitive information when sending it over a network
and the two programs used for running a shell (usually back then, the Bourne Shell, `sh`) on, or copying
files to, a remote machine were named `rsh` and `rcp`, respectively. Think (`r`)emote `sh` and `cp`

However, anyone could watch the unencrypted network traffic, which meant that villains could
steal usernames and passwords,
and use them for all manner of nefarious purposes.

The [SSH protocol]({{ page.root }}/reference/{{ site.index }}#ssh-protocol)
was invented to prevent this (or at least slow it down).
It uses several sophisticated, and heavily tested, encryption protocols
to ensure that outsiders can't see what's in the messages
going back and forth between different computers.

The remote login server which accepts connections from client programs
is known as the [SSH daemon]({{ page.root }}/reference/{{ site.index }}#ssh-daemon), or `sshd`.

The client program we use to login remotely is
the [secure shell]({{ page.root }}/reference/{{ site.index }}#secure-shell),
or `ssh`, think (`s`)ecure `sh`.

The `ssh` login client has a companion program called `scp`, think  (`s`)ecure `cp`,
which allows us to copy files to or from a remote computer using the same kind of encrypted connection.


## A remote login using `ssh`

To make a remote login, we issue the command `ssh username@computer`
which tries to make a connection to the SSH daemon running on the remote computer we have specified.

After we log in,
we can use the remote shell to use the remote computer's files and directories.

Typing `exit` or Control-D
terminates the remote shell, and the local client program, and returns us to our previous shell.

In the example below Nelle connects to a computer called `neptune.aquatic.edu`.
The remote machine's command prompt is `neptune>`
instead of just `$`.
To make it clearer which machine is doing what,
we'll indent the commands sent to the remote machine
and their output.

~~~
$ pwd
~~~
{: .language-bash}

~~~
/users/nelle
~~~
{: .output}

~~~
$ ssh nelle@neptune.aquatic.edu
Password: ********
~~~
{: .language-bash}

~~~
    neptune> hostname
~~~
{: .language-bash}

~~~
    neptune
~~~
{: .output}

~~~
    neptune> pwd
~~~
{: .language-bash}

~~~
    /home/nelle
~~~
{: .output}

~~~
    neptune> ls -F
~~~
{: .language-bash}

~~~
    bin/     fish.txt   deep_sea/   rocks.cfg
~~~
{: .output}

~~~
    neptune> exit
~~~
{: .language-bash}

~~~
$ pwd
~~~
{: .language-bash}

~~~
/users/nelle
~~~
{: .output}

> ## Logging into a remote system
> Open a connection to a remote system you have access to.
>
> The first time you connect to a remote computer you will see a message saying
> that the authenticity of the host can't be established. This is normal
> because you've never connected to that computer before, so we have no record
> of the key fingerprint which identifies that computer. If you receive this
> message on a subsequent connection then it is a sign that the remote computer
> has been changed (most likely the OS was reinstalled, but the system *could*
> have been hacked) or (much less likely) that somebody is interfering with
> the encryption of your connection. To accept the fingerprint of the remote
> system you must type "yes".
>
{: .challenge}

> ## Differences between remote and local system
>
> Open a second terminal window on your local computer.
>
> What differences do you see?
>
> Are the prompts the same?
>
> Run the `ls` command and see if the output style looks the same.
>
> > ## Solution
> >
> > You might find that the prompt has different information and if it displays
> >  a host (computer) name then this should be different. This is very
> > important for making sure you know what system you are issuing commands on
> > when in the shell. You might also find the colours are different,
> > especially when running the `ls` command.
> {: .solution}
{: .challenge}

## Copying files to, and from a remote machine using `scp`

To copy a file,
we specify the source and destination paths,
either of which may include computer names.
If we leave out a computer name,
`scp` assumes we mean the machine we're running on.

Using our web browser let's download some of Nelle's data which is stored in 
a zip file with this lesson from:
[{{ site.url }}/data/north-pacific-gyre.zip]({{page.root}}/data/north-pacific-gyre.zip).

Then we can copy it to a remote server with `scp`:

~~~
scp ~/Downloads/north-pacific-gyre.zip nelle@backupserver:backups/north-pacific-gyre-2012-07-03.zip
Password: ********
~~~
{: .language-bash}

~~~
north-pacific-gyre.zip    100%   40KB 554.5KB/s   00:00
~~~
{: .output}

Note the colon `:`, seperating the hostname of the server and the pathname of
the file we are copying to.
It is this character that informs `scp` that the source or target of the copy is
on the remote machine and the reason it is needed can be explained as follows:

In the same way that the default directory into which we are placed when running
a shell on a remote machine is our home directory on that machine, the default
target, for a remote copy, is also the  home directory.

This means that

~~~
scp ~/Downloads/north-pacific-gyre.zip nelle@backupserver:
~~~
{: .language-bash}

would copy `north-pacific-gyre.zip` into our home directory on `backupserver`, however,
if we did not have the colon to inform `scp` of the remote machine, we would
still have a valid commmad.

~~~
scp ~/Downloads/north-pacific-gyre.zip nelle@backupserver:
~~~
{: .language-bash}

but now we have merely created a file called `nelle@backupserver` on our local
machine, as we would have done with `cp`.

~~~
cp ~/Downloads/north-pacific-gyre.zip nelle@backupserver
~~~
{: .language-bash}

Copying a whole directory betwen remote machines uses the same syntax as the
`cp` command: we just use the `-r` option to signal that we want copying to
be recursively. For example, this command copies all of our results from the
backup server to our laptop:

~~~
scp -r nelle@backupserver:backups ./backups
Password: ********
~~~
{: .language-bash}

~~~
results-2011-09-18.dat              100%  7  1.0 MB/s 00:00
results-2011-10-04.dat              100%  9  1.0 MB/s 00:00
results-2011-10-28.dat              100%  8  1.0 MB/s 00:00
results-2011-11-11.dat              100%  9  1.0 MB/s 00:00
~~~
{: .output}

> ## Choose the right command
> Which of the following would you use to copy a directory called `data` and
> all the files and subdirectories contained within it to the `/data` directory
> on a remote computer called `datastore.aquatic.edu`:
>
> 1. scp data nelle@datastore.aquatic.edu
> 2. cp -r data nelle@datastore.aquatic.edu:
> 3. scp -r data nelle@datastore.aquatic.edu:/data
> 4. scp data nelle@datastore.aquatic.edu:
>
> > ## Solution
> > 3 is the correct answer.
> >
> > 1 does not have `-r` option to copy all subdirectories and is missing the
> > `:` to specify the path on the remote computer. It will create a file
> > called `nelle@datastore.aquatic.edu` on the local computer.
> >
> > 2 uses the `cp` command instead of `scp`, it will only copy files on the
> > local computer.
> >
> > 4 is missing the `-r` option to copy the subdirectories and doesn't specify
> > `/data` as the destination path.
> {: .solution}
{: .challenge}

> ## Copy Nelle's data to your SSH server
> Download [{{page.root}}/data/north-pacific-gyre.zip]({{page.root}}/data/north-pacific-gyre.zip)
> to your computer using your web browser. This will typically place the file
> `north-pacific-gyre.zip` in your Downloads folder.
> Using `scp` copy the file to a server you have SSH access to.
>
> > ## Solution
> > ~~~
> > scp ~/Downloads/north-pacific-gyre.zip myuser@myserver
> > ~~~
> > {: .langauge-bash}
> {: .solution}
{: .challenge}

## Running commands on a remote machine using `ssh`

Here's one more thing the `ssh` client program can do for us.
Suppose we want to check whether we have already created the file
`north-pacific-gyre.zip` on the backup server.
Instead of logging in and then typing `ls`,
we could do this to list all the zip files:

~~~
ssh nelle@backupserver "ls *.zip"
Password: ********
~~~
{: .language-bash}

~~~
north-pacific-gyre.zip
2012-07-04.zip
~~~
{: .output}

Here, `ssh` takes the argument after our remote username
and passes them to the shell on the remote computer.
(We have to put quotes around it to make it look like a single argument.)
Since those arguments are a legal command,
the remote shell runs `ls *.zip` for us
and sends the output back to our local shell for display.

## SSH Keys

Typing our password over and over again is annoying,
especially if the commands we want to run remotely are in a loop.
To remove the need to do this,
we can create an [SSH key]({{ page.root }}/reference/{{ site.index }}#ssh-key)
to tell the remote machine
that it should always trust us.

SSH keys come in pairs, a public key that gets shared with services like GitHub,
and a private key that is stored only on your computer. If the keys match,
you're granted access.

The cryptography behind SSH keys ensures that no one can reverse engineer your
private key from the public one.

The first step in using SSH authorization is to generate your own key pair.

You might already have an SSH key pair on your machine. You can check to see if
one exists by moving to your `.ssh` directory and listing the contents.

~~~
$ cd ~/.ssh
$ ls
~~~
{: .language-bash}

If you see `id_rsa.pub`, you already have a key pair and don't need to create a
new one.

If you don't see `id_rsa.pub`, use the following command to generate a new key
pair. Make sure to replace `your@email.com` with your own email address.

~~~
$ ssh-keygen -t rsa -C "your@email.com"
~~~
{: .language-bash}

When asked where to save the new key, hit enter to accept the default location.

~~~
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/username/.ssh/id_rsa):
~~~
{: .output}

You will then be asked to provide an optional passphrase. This can be used to
make your key even more secure, but if what you want is avoiding type your
password every time you can skip it by hitting enter twice.

~~~
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
~~~
{: .output}

When the key generation is complete, you should see the following confirmation:

~~~
Your identification has been saved in /Users/nelle/.ssh/id_rsa.
Your public key has been saved in /Users/nelle/.ssh/id_rsa.pub.
The key fingerprint is:
01:0f:f4:3b:ca:85:d6:17:a1:7d:f0:68:9d:f0:a2:db nelle@eurphoic.edu
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|                 |
|        . E +    |
|       . o = .   |
|      . S =   o  |
|       o.O . o   |
|       o .+ .    |
|      . o+..     |
|       .+=o      |
+-----------------+
~~~
{: .output}

The random art image is an alternate way to match keys but we won't be needing this.

Now you need to place a copy of your public key ony any servers you would
like to use SSH to connect to, instead of logging in with a username and
passwd.

Display the contents of your new public key file with `cat`:

~~~
$ cat ~/.ssh/id_rsa.pub
~~~
{: .language-bash}

~~~
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA879BJGYlPTLIuc9/R5MYiN4yc/YiCLcdBpSdzgK9Dt0Bkfe3rSz5cPm4wmehdE7GkVFXrBJ2YHqPLuM1yx1AUxIebpwlIl9f/aUHOts9eVnVh4NztPy0iSU/Sv0b2ODQQvcy2vYcujlorscl8JjAgfWsO3W4iGEe6QwBpVomcME8IU35v5VbylM9ORQa6wvZMVrPECBvwItTY8cPWH3MGZiK/74eHbSLKA4PY3gM4GHI450Nie16yggEg2aTQfWA1rry9JYWEoHS9pJ1dnLqZU3k/8OWgqJrilwSoC5rGjgp93iu0H8T6+mEHGRQe84Nk1y5lESSWIbn6P636Bl3uQ== nelle@aquatic.edu
~~~
{: .output}

Copy the contents of the output.

Login to the remote server with your username and password.

~~~
$ ssh nelle@neptune.aquatic.edu
Password: ********
~~~
{: .language-bash}

Paste the content that you copy at the end of `~/.ssh/authorized_keys`.

~~~
    neptune> nano ~/.ssh/authorized_keys
~~~
{: .language-bash}

After append the content, logout of the remote machine and try login again. If
you setup your SSH key correctly you won't need to type your password.

~~~
    neptune> exit
~~~
{: .language-bash}

~~~
$ ssh nelle@neptune.aquatic.edu
~~~
{: .language-bash}





> ## Create an SSH key 
> Create an SSH key with the `ssh-keygen` command. 
> Don't add a pass-phrase to it at this stage, we'll do that next.
{: .challenge}


> ## Add (or change) a key's passphrase
> Add a passphrase to your key with the command `ssh-keygen -p`.
>
{: .challenge}


## Authorising SSH keys

The example of copying our public key to a remote machine, so that it
can then be used when we next SSH into that remote machine, assumed
that we already had a directory `~/.ssh/`.

Whilst a remote server may support the use of SSH to login, your home
directory there may not contain a `.ssh` directory by default.

We have already seen that we can use SSH to run commands on remote
machines, so we can ensure that everything is set up as required before
we place the copy of our public key on a remote machine.

The long way to do this is to copy the contents of our SSH public key
into the file `.ssh/authorized_keys` on the remote machine. 
The `authorized_keys` file can contain multiple keys, one on each line.
Each key will represent a different computer we might connect **FROM**.

SSH provides a convienient command to copy the key to a server called
`ssh-copy-id`. This will read our SSH public key and append it to the
`~/.ssh/authorized_keys` file on a remote machine and create it if it
does not exist.

Firstly, let's check if we have a `.ssh/` directory on another remote
machine, `beagle`

~~~

Password: ********
~~~
{: .language-bash}

~~~
    ls: cannot access /home/nelle/.ssh: No such file or directory
~~~
{: .output}

Oh dear, we don't have a `.ssh` directory! 
We chould create the directory; and check that it's there.
But let's have `ssh-copy-id` do the hard work for us:

~~~
$ ssh-copy-id nelle@beagle
Password: ********

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'nelle@beagle'"
and check to make sure that only the key(s) you wanted were added.

~~~
{: .language-bash}

Let's try loging in again, this time there should be no password prompt
and there should be a `.ssh` directory.

~~~
$ ssh nelle@beagle "ls -ld ~/.ssh"
drwxr----- 2 nelle nelle 512 Jan 01 09:09 /home/nelle/.ssh
~~~
{: .output}

> ## Setup an SSH key for yourself
> 1. Install it on a remote server using the `ssh-copy-id` command.
> 2. Verify it works by running SSH and checking you aren't prompted for a 
> password.
> 3. Verify you have a `~/.ssh/authorized_keys` file, display the contents of this
> using the `cat` command. How many keys does it contain?
> 
> Note: that some systems are configured to not allow SSH keys or to require
> a password AND an SSH key for extra security. Some also don't allow password
> logins and will have another mechanism to load a key before you login for the
> first time, this is often via a web portal.
>
{: .challenge}

{% include links.md %}
