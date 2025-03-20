---
title: Streams
teaching: 10
exercises: 0
questions:
- "What are the standard output streams?"
- "How can I redirect them?"
objectives:
- "Understand the difference betwen STDERR and STDOUT."
- "Split STDOUT and STDERR output with 2> and 1> redirects."
- "Use the `tee` command to redirect to a file and the screen."
keypoints:
- ""
---

There are three standard input/outputs streams created when you run a Unix command. These can be thought of as the transfer of data to and from your command. The three streams are standard input (STDIN), standard output (STDOUT) and stderr (STDERR).

## STDIN

STDIN the the stream by which the program you are running is provided with its input data. Unix automatically connects this to your terminal keyboard. For example, when you are entering your password or passphrase when ssh-ing into a remote server, you are using STDIN. 

## STDOUT vs STDERR

STDOUT and STDERR are both connected to your terminal screen. STDOUT is the stream used by the program you are running for its output data and STDERR is the stream for any error messages or diagnostics such as log messages. 

For example,

~~~
bash do-stats.sh 2012-07-03/NENE01812A.txt
~~~
{: .language-bash}

results in

~~~
2012-07-03/NENE01812A.txt
~~~
{: .output}

being printed to the terminal. This is because we used `echo` in `do-stats.sh` - echo uses the output stream.

If we make a typo and run

~~~
bash do-stat.sh 2012-07-03/NENE01812A.txt 
~~~
{: .language-bash}

we get

~~~
bash: do-stat.sh: No such file or directory
~~~
{: .output}

printed to the terminal. This is actually using the error stream, but because STDOUT and STDERR are both automatically displayed by your terminal, it might not immediately be obvious that these two streams are different.

However, they can be separated. This means that you can stop error messages and warnings being mixed in with your output. 

Let's remind ourselves of how to redirect the output from a command to a text file (as we saw in [the Introduction to Unix Shell workshop](https://swcarpentry.github.io/shell-novice/04-pipefilter.html#capturing-output-from-commands)), uing the `>` symbol.

~~~
bash do-stats.sh 2012-07-03/NENE01812A.txt > output.txt
~~~
{: .language-bash}

Now there is nothing printed to the screen, because our output is being redicted to a file named `output.txt`. 

~~~
cat output.txt 
~~~
{: .language-bash}

~~~
2012-07-03/NENE01812A.txt
~~~
{: .output}

Let's repeat this, but, this time use our command with a typo from before that we know will generate an error.

~~~
bash do-stat.sh 2012-07-03/NENE01812A.txt > output.txt
~~~
{: .language-bash}

~~~
bash: do-stat.sh: No such file or directory
~~~
{: .output}

In this case, the error is still printed to the terminal, because `>`, by default, redirects STDOUT, not STDERR. 

## `2>` and `1>` redirects

We've just seen that `>` redirects STDOUT and not STDERR. However, it can be used to redirect STDERR, or both. Putting a number in front of the `>` controls which stream it redirects. `1` is the stream ID of STDOUT, so `1>` is the same as `>`. 

~~~
bash do-stats.sh 2012-07-03/NENE01812A.txt 1> output.txt 
~~~
{: .language-bash}

To redirct STDERR, use a stream ID of 2, i.e. `2>`. 

~~~
bash do-stat.sh 2012-07-03/NENE01812A.txt 2> error.txt
~~~
{: .language-bash}

~~~
cat error.txt
~~~
{: .language-bash}

~~~
bash: do-stat.sh: No such file or directory
~~~
{: .output}

(The stream ID of STDIN is 0.)

It is also possible to redirect both the output and error streams at once. If you want both streams redirected to the same file you can do:

~~~
Example of both STDERR and STDOUT being redirected to a file by 2>&1.
~~~
{: .language-bash}

This redirects STDOUT to a text file, then redirects STDERR to whever STDOUT is being redirected to.

If you want to redirect STDERR and STDOUT to two different files, this can be done with:

~~~
Example of STDERR and STDOUT being redirected to two different files.
~~~
{: .language-bash}


## The `tee` command 

The Unix command [`tee`](https://en.wikipedia.org/wiki/Tee_(command)) 
duplicates STDOUT and sends the second copy to a file.

Consider the input/output stream model we've already discussed as a system of pipes.
`tee` sensibly splits the flow of information, allowing one copy to be written 
to disk and leaving one copy available for a subsequent command in the chain.

Where might this be useful?  For instance, you can use this to both passively 
log and actively monitor a compilation or a data processing step.

Because `tee` preserves STDOUT, it allows recovery from actions that overwhelm 
the buffer of your shell's window as well, which is often limited.

> ## Some exercise
> 
>
> > ## Solution
> > And some solution
> {: .solution}
{: .challenge}
