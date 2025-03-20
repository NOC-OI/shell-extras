---
title: "Introduction"
teaching: 5
exercises: 0
questions:
- "What is the pre-requisite knowledge for this workshop."
objectives:
- "Recall the commands covered in the Introduction to Unix shell Workshop."
- "Recall Nelle's pipeline."
keypoints:
- "Familarity with the basic shell commands covered in the introductory lesson
is assumed."
- "Nelle's pipeline is available as a shell script which runs the `goostats`
program on an entire dataset."
---

# Recap of basic shell commands

This workshop assumes you are familiar with the material in the Introduction to
Unix Shell Software Carpentry lesson. Below is a quick recap of that lesson.

## What is the shell

- "A shell is a program whose primary purpose is to read commands and run other programs."
- "The shell's main advantages are its high action-to-keystroke ratio, its support for automating repetitive tasks, and its capacity to access networked machines."
- "The shell's main disadvantages are its primarily textual nature and how cryptic its commands and operation can be."

## Command History

- "Use the up-arrow key to scroll up through previous commands to edit and repeat them."
- "Use `Ctrl-R` to search through the previously entered commands."
- "Use `history` to display recent commands, and `!number` to repeat a command by number."

## Files

- "`cd path` changes the current working directory."
- "`ls path` prints a listing of a specific file or directory; `ls` on its own lists the current working directory."
- "`pwd` prints the user's current working directory."
- "`/` on its own is the root directory of the whole file system."
- "A relative path specifies a location starting from the current location."
- "An absolute path specifies a location from the root of the file system."
- "Directory names in a path are separated with `/` on Unix, but `\\` on Windows."
- "`..` means 'the directory above the current one'; `.` on its own means 'the current directory'."
- "Most files' names are `something.extension`. The extension isn't required, and doesn't guarantee anything, but is normally used to indicate the type of data in the file."

## Files and Directories

- "`cp old new` copies a file."
- "`mkdir path` creates a new directory."
- "`mv old new` moves (renames) a file or directory."
- "`rm path` removes (deletes) a file."
- "`*` matches zero or more characters in a filename, so `*.txt` matches all files ending in `.txt`."
- "`?` matches any single character in a filename, so `?.txt` matches `a.txt` but not `any.txt`."

## Text Editors

- "Nano is a simple text editor available on most Unix systems."
- "Use of the Control key may be described in many ways, including `Ctrl-X`, `Control-X`, and `^X`."
- "Depending on the type of work you do, you may need a more powerful text editor than Nano."

## Pipes and Filters

- "`cat` displays the contents of its inputs."
- "`head` displays the first 10 lines of its input."
- "`tail` displays the last 10 lines of its input."
- "`sort` sorts its inputs."
- "`wc` counts lines, words, and characters in its inputs."
- "`command > file` redirects a command's output to a file."
- "`first | second` is a pipeline: the output of the first command is used as the input to the second."
- "The best way to use the shell is to use pipes to combine simple single-purpose programs (filters)."

## Loops

- "A `for` loop repeats commands once for every thing in a list."
- "Every `for` loop needs a variable to refer to the thing it is currently operating on."
- "Use `$name` to expand a variable (i.e., get its value). `${name}` can also be used."
- "Do not use spaces, quotes, or wildcard characters such as '*' or '?' in filenames, as it complicates variable expansion."
- "Give files consistent names that are easy to match with wildcard patterns to make it easy to select them for looping."

## Shell Scripts

- "Save commands in files (usually called shell scripts) for re-use."
- "`bash filename` runs the commands saved in a file."
- "`bash -x filename` runs a script in debug mode." 
- "`$@` refers to all of a shell script's command-line arguments."
- "`$1`, `$2`, etc., refer to the first command-line argument, the second command-line argument, etc."
- "Place variables in quotes if the values might have spaces in them."
- "Letting users decide what files to process is more flexible and more consistent with built-in Unix commands."

## Find and Grep
- "`find` finds files with specific properties that match patterns."
- "`grep` selects lines in files that match patterns."
- "`--help` is a flag supported by many bash commands, and programs that can be run from within Bash, to display more information on how to use these commands or programs."
- "`man command` displays the manual page for a given command."
- "`$(command)` inserts a command's output in place."

# Nelle's Pipeline

The Introduction to Unix Shell lesson was built around the story of Nelle Nemo,
a marine biologist, who had just returned from a six-month survey of the
[North Pacific Gyre](http://en.wikipedia.org/wiki/North_Pacific_Gyre),
where she has been sampling gelatinous marine life in the
[Great Pacific Garbage Patch](http://en.wikipedia.org/wiki/Great_Pacific_Garbage_Patch).
She had 1520 samples in all and needed to:

1.  Run each sample through an assay machine
    that will measure the relative abundance of 300 different proteins.
    The machine's output for a single sample is
    a file with one line for each protein.
2.  Calculate statistics for each of the proteins separately
    using a program her supervisor wrote called `goostats`.
3.  Write up results.
    Her supervisor would really like her to do this by the end of the month
    so that her paper can appear in an upcoming special issue of *Aquatic Goo Letters*.

It takes about half an hour for the assay machine to process each sample.
The good news is that
it only takes two minutes to set each one up.
Since her lab has eight assay machines that she can use in parallel,
this step will "only" take about two weeks.

The bad news is that if she had to run `goostats` by hand using a GUI,
she would have to select a files using an open file dialog 1520 times.
At 30 seconds per sample,
the whole process will take more than 12 hours
(and that's assuming the best-case scenario where she is ready to select the
next file as soon as the previous sample analysis has finished).

### A shell script for Nelle's pipeline

During the Introduction to Unix shell lesson we developed a shell script to
help run Nelle's pipeline. This did the following:

- Looped through a list of files
- Displays the filename it is currently processing on screen
- Runs the `goostats` script on the file and creates an output file with a name starting with `stats-`

This script is saved as do-stats.sh and contains the following code:

~~~
for datafile in "$@"
do
    echo $datafile
    bash goostats $datafile stats-$datafile
done
~~~
{: .language-bash}


This is run with the command:

~~~
bash do-stats.sh NENE*[AB].txt
~~~
{: .language-bash}

This runs with all files starting with the name "NENE" and ending in "A" or 
"B".

### Nelle's new challenge

Nelle now has a new dataset to process that is much bigger than the previous
one, it is taking a long time to process on her laptop. A colleague has
suggested she uses her group's Linux server instead. To use this she will
need to transfer her data to the server too.

She would also like to do the following:

- Allow the students in her group to help with the analysis and they will need
permission to access the files.
- Keep track of how much disk space her analysis is using since her research
group is billed based on how much disk space they use.
- Archive her data and send this to a colleague and to an archive service.
- Improve the way her script handles errors and have it print some helpful
error messages when data isn't formatted correctly.
- Make her code configurable depending on some attributes of the computer
processing it.
- She has just been given another dataset processed with a new assay machine.
This data is a slightly different format and her processing code needs to be
adapted for it.

Let's help Nelle to make these modifications to her pipeline.
