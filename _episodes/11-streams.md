---
title: Streams
teaching: 10
exercises: 0
questions:
- "What are the standard output streams?"
- "How can I redirect them?"
objectives:
- "Understand the difference betwen STDERR and STDOUT."
- "Split STDOUT and STDERR output with the 2> and 1> redirects."
- "Use the `tee` command to redirect to a file and the screen."
keypoints:
- ""
---

There are three standard input/outputs streams created when you run a Unix command. These can be thought of as the transfer of data to and from your command. The three streams are standard input (STDIN), standard output (STDOUT) and stderr (STDERR).

## STDIN

STDIN the the stream by which the program you are running is provided with its input data. Unix automatically connects this to your terminal keyboard. 

Example STDIN

## STDOUT vs STDERR

STDOUT and STDERR are both connected to your terminal screen. STDOUT is the stream used by the program you are running for its output data and STDERR is the stream for any error messages or diagnostics such as log messages. 

~~~
Example STDOUT
~~~
{: .bash}

~~~
Example STDERR
~~~
{: .bash}

Because STDOUT and STDERR both automatically displayed by your terminal, it might not immediately be obvious that these two streams are different.

~~~
Example of STDOUT and STDERR mixed together
~~~
{: .bash}

However, they can be separated. This means that you can stop error messages and warnings being mixed in with your output. 

Let's remind ourselves of how to redirect the output from a command to a text file (as we saw in [the Introduction to Unix Shell workshop](https://swcarpentry.github.io/shell-novice/04-pipefilter.html#capturing-output-from-commands)), uing the `>` symbol.

~~~
Example of redirection
~~~
{: .bash}

Now let'd try redirecting the output of a command to a text file, but this time, let's use a command we know will generate an error.

~~~
Example of redirection with an error printed to the terminal
~~~
{: .bash}

In this case, the error is still printed to the terminal, because `>`, by default, redirects STDOUT, not STDERR. 

## `2>` and `1>` redirects

We've just seen that `>` redirects the STDOUT. However, it can be used to redirect the STDERR, or both. Putting a number in front of the `>` controls which stream it redirects. `1` refers to STDOUT, so `1>` is the same as `>`. 

~~~
Same example of redirection as before (without error), but using 1> rather than >. 
~~~
{: .bash}

To redirct STDERR, use `2>`. 

~~~
Same example of redirection as two above but with the error redirected to a file.
~~~
{: .bash}

It is also possible to redirect both streams at once. If you want both streams redirected to the same file you can do:

~~~
Example of both STDERR and STDOUT being redirected to a file by 2>&1.
~~~
{: .bash}

This redirects STDOUT to a text file, then redirects STDERR to whever STDOUT is being redirected to.

If you want to redirect STDERR and STDOUT to two different files, this can be done with:

~~~
Example of STDERR and STDOUT being redirected to two different files.
~~~
{: .bash}


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
> Some exercise
>
> > ## Solution
> > And some solution
> {: .solution}
{: .challenge}
