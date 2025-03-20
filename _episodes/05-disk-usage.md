---
title: "Disk Usage"
teaching: 15
exercises: 5
questions:
- "How do we find out how big a directory is on the command line?"
- "How do we find out how much space is left on a disk from the command line?"
objectives:
- "Understand that the `du` command tells us how much disk space a directory uses."
- "Understand that the `df` command tells us how much space is free on a particular disk."
keypoints:
- "The `du` command tells us how much disk space a directory is using."
- "The `-h` option to `du` gives us human readable units such a K, M and G."
- "The `df` command tells us how much space is in use on a disk."
- "The `df` command can also take a `-h` option for human readable units."
- "On some shared systems the `quota` command tells us how much space is left in our disk allocation."
---

# Measuring Disk Usage

## How big is that directory?

Now that Nelle has two datasets (one for 2012-07-03 and one for 2012-07-04) on
her computer she is wondering how much disk space these are using. The `du`
command is useful here as it tells us how much disk space is used by an entire
directory, all it's subdirectories and all the files they contain.

If we run this in the directory above `north-pacific-gyre` then we the command

~~~
du north-pacific-gyre
~~~
{: .langauge-bash}

will tell us how big the entire `north-pacific-gyre` directory is in bytes.
Reading this number in bytes can become difficult when we get into even the
range of megabytes (millions of bytes) and certainly when it is gigabytes or 
more. Fortunately `du` has a "human readable" option which will use units of
kilobytes/megabyte/gigabytes/terabytes etc with the K/M/G/T suffixes. If we
repeat our command with the the `-h` option then we will get this suffix.

~~~
du -h north-pacific-gyre
~~~
{: .langauge-bash}

> ## Marketing Kilobytes vs Kilobytes
> Traditionally a kilobyte was defined as 1024 bytes (2 to the power 10) and
> a megabyte 1024 kilobytes, a gigabyte 1024 megabytes etc. But often this is
> approximated to 1000 bytes in a kilobyte etc. At smaller scales the
> differences are quite small, but they multiply with each order of mangitude.
> Sometimes the large power of 2 units are known as kebi/mebi/gebi/tebibytes,
> abbreviated KiB/MiB/GiB/TiB and the power of 10 versions as KB/MB/GB/TB.
>
> The list below shows how these numbers compare as we move up the scale:
>
> * 1,024B = 1 KiB = 1.024 KB
> * 1,048,576B = 1 MiB = 1.049 MB
> * 1,073,741,824B = 1 GiB = 1.074 GB
> * 1,099,511,627,776B = 1 TiB = 1.1 TB
>
> As we can see by the time we get into the terabyte range there is almost
> a 10% discrepancy between the number of bytes in a terabyte and a tebibyte.
> When you are selling storage being able to claim that you have a 1.1TB disk
> instead of a 1TB disk then this can be quite a marketing advantage.
> This has developed the term "Marketing Mega(Giga|Tera)bytes".
> The `du` command defaults to using 1024 byte kilobytes (kebibytes), but if
> we want 1000 byte kilobytes then we can add the option `--si`.
{: .callout}

> ## Explore the `-s` option to `du`
> Try out the `-s` option to `du`. Find out what it does from the man or help
> page. When/why might this option be useful?
>
> > ## Solution
> > This option shows a summary of how much disk space is used by the entire
> > directory without telling us any information about each subdirectory.
> > This can be useful when we don't want all the information about the 
> > subdirectories and just the total. When there are a lot of subdirectories
> > this can be much faster to run too. 
> {: .solution}
{: .challenge}

## How much disk space do we have?

The `du` command is great for telling us how much space we've used in a given
directory but it doesn't tell us how much free space we have. For that we have
another command called `df` which is short for "disk free". With no arguments
this will tell us how much free space we have on every disk mounted on this
system in bytes. Like `du`, there is a `-h` option for human readable formats.

~~~
df -h
~~~
{: .language-bash}

On a lot of shared systems such as High Performance Computing systems it is
common for each user to receive a quota for their home directory (and possibly
some other directories). This limits how much they can use, even if there is
plenty more space on the disk. Running `df` on such a system will return how
much space is free on the entire disk, not for the current user. On many
systems the `quota` command will tell you how much space is left in your disk
quota. The quota command defaults to displaying disk usage in a unit of "blocks"
these are usually 1KB each. Like the `df` and `du` commands there is a human
readable option, but this time it is `-s` not `-h`.

~~~
quota -s
~~~
{: .language-bash}


{% include links.md %}
