---
title: Streams
teaching: 10
exercises: 0
questions:
- ""
objectives:
- "Understand the difference betwen STDERR and STDOUT."
- "Split STDOUT and STDERR output with the 2> and 1> redirects."
- "Use the `tee` command to redirect to a file and the screen."
keypoints:
- ""
---

The Unix command [`tee`](https://en.wikipedia.org/wiki/Tee_(command)) 
duplicates STDOUT and sends the second copy to a file.

Consider the input/output stream model we've already discussed as a system of pipes.
`tee` sensibly splits the flow of information, allowing one copy to be written 
to disk and leaving one copy available for a subsequent command in the chain.

Where might this be useful?  For instance, you can use this to both passively 
log and actively monitor a compilation or a data processing step.

Because `tee` preserves STDOUT, it allows recovery from actions that overwhelm 
the buffer of your shell's window as well, which is often limited.
