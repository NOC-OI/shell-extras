---
title: "Working with archive files"
teaching: 15
exercises: 5
questions:
- "Understanding how to extract and compress archive files."
- "What is the difference between a tar and zip file?"
objectives:
- "What are archive files?"
- "How to extract a zip archive."
- "How to extract a tar archive."
- "How to create a zip archive."
- "How to create a tar archive."
- "How to compress a tar archive."
keypoints:
- "Archive files are files which contain one or more other files. They are a convienient way to store or transfer multiple files and directory structures inside a single file."
- "Zip archives are (usually) compressed by default."
- "Zip files can be extracted with the `unzip` command."
- "Zip files can be created with the `zip` command."
- "Tar archives are not compressed."
- "Tar archives can be compressed using the `gzip` or `bzip2` utilities."
- "Tar files can be extracted with the `tar -xf` option."
- "Modern versions of tar will automatically uncompress gzipped or bzipped archives."
- "Tar files can be created with the `tar -cf` option."
---

# Archive Files

There are many times where it is useful and/or convienient to store multiple 
files and directory sturctures inside a single file. Probably the three most
common use cases for this are when we want to store a set of files, to copy them
or to compress them.

## Archiving 

We might want to store a collection of files for long term preservation in a way
that somebody else can easily obtain them with the download of a single file.
Common platforms for this include the Zenodo archiving service or Github 
(through it's releases feature).

## File transfer

When copying a file to another computer either via email, a file transfer 
protocol such as SCP or even a memory stick/card it can often be convienient
if we can copy just a single file rather than a whole set of files. This is 
especially true when there is a complex directory sturcture that goes with it.

## Compression

Most archive formats at least have the option (some do it by default) to
compress the data in the archive to make it take less disk space and transfer
faster over a network. These compression formats are usually "lossless" formats
which work by trying to remove redundant data in files but allow the data to be
completley recreated when uncompressed without loosing anything. This is in
contrast to "lossy" formats such as JPEG (for images), MP3 (for audio) and MPEG
(for video) which remove some information that is unlikely to be perceived by
people but can reduce the file size. As a result these lossless compression
systems work well when compressing previously uncompressed data such as text,
CSV or code files or raw images, but they do not work very well on previously
compressed files such as JPEG or PNG images, MP3 audio or MPEG video.
Compression rates of 20-50% for text files are not uncommon, which can be a
significant saving when storing or transferring data. Compression can also be
very helpful when emailing files as most email systems have a size limit of 
between 8 and 20 megabytes.

## Zip files

One of the most popular archive formats is the ZIP format, which as the name
suggests is both a compression and archiving format. ZIP files are more common
in the Windows world than the Unix world as they didn't always support Unix
file permission and ownership information.

### Extracting a Zip file

In the last episode we copied a ZIP file called `north-pacific-gyre.zip` to a
remote server using the `scp` command. We can now use the `unzip` commmand to
list and extract the contents of that ZIP file.

First let's connect to the remote system using SSH and check the file is there.

~~~
ssh nelle@backupserver
ls -lh north-pacific-gyre.zip
~~~
{: .language-bash}

We should see our `north-pacific-gyre.zip` file listed along with some metadata
about it including who own's it, it's size and creation date/time.

~~~
-rw-rw-r-- 1 nelle nelle 41K Mar 17 18:33 north-pacific-gyre.zip
~~~
{: .output}

Now that we are sure the file is available to us let's have a look at what is
inside it using the `unzip -l` command.

~~~
unzip -l north-pacific-gyre.zip
~~~
{: .language-bash}

~~~
Archive:  north-pacific-gyre.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2025-03-17 18:27   north-pacific-gyre/
        0  2025-03-17 18:27   north-pacific-gyre/2012-07-03/
     4400  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01729B.txt
     4391  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE02040A.txt
     4406  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01729A.txt
     4371  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01736A.txt
     4393  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE02043B.txt
     4389  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01978B.txt
     4401  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01812A.txt
     3517  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE02018B.txt
     4381  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01978A.txt
     4381  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE02040Z.txt
     4386  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE02043A.txt
     4375  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01843B.txt
     4411  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01751A.txt
     4395  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01843A.txt
     4372  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01971Z.txt
     4367  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE02040B.txt
     4409  2017-02-16 15:58   north-pacific-gyre/2012-07-03/NENE01751B.txt
      219  2025-03-17 18:33   north-pacific-gyre/goostats
      345  2025-03-17 18:33   north-pacific-gyre/goodiff
       92  2025-03-17 18:33   north-pacific-gyre/do-stats.sh
---------                     -------
    74401                     22 files
~~~
{: .output}

This shows that all the files in the archive are inside a directory called
`north-pacific-gyre`. Inside this we have a subdirectory called `2012-07-03`
with some text files in it and in the main directory we have the `goostats`,
`goodiff` and `do-stats.sh` programs/shell scripts.

Let's go ahead and extract this ZIP file, do that we simply run the `unzip` 
command with the ZIP file name as an argument.

~~~
unzip north-pacific-gyre.zip
~~~
{: .language-bash}

If we run the `ls` command after this we should see a `north-pacific-gyre` 
directory now exists and if we `cd` into this and run `ls` again there should
be a `2012-07-03` subdirectory and the `goostats`, `goodiff` and `do-stats.sh`
prgorams. 

~~~
ls
cd north-pacific-gyre
ls
~~~
{: .language-bash}

### Creating a ZIP file

We can create our own ZIP archives using the `zip` command. This takes the name
of the ZIP file to create followed by a list of filenames. We previously found 
that Nelle has files named after which machine was used to process her samples.
This is the "A" or "B" at the end of the filename before the ".txt" extension.
There are a few samples which have a "Z" in the name where it was not known
which machine processed them. Let's create a new archive in the
`north-pacfiic-gyre/2012-07-03` directory which contains just the file ending
"A" or "B".

~~~
cd 2012-07-03
zip goodfiles.zip NENE*[AB].txt
~~~
{: .language-bash}

This will display the names of all the files added to our new ZIP file and the
amount of compression (deflation) that is applied.

~~~
  adding: NENE01729A.txt (deflated 51%)
  adding: NENE01729B.txt (deflated 51%)
  adding: NENE01736A.txt (deflated 51%)
  adding: NENE01751A.txt (deflated 51%)
  adding: NENE01751B.txt (deflated 51%)
  adding: NENE01812A.txt (deflated 51%)
  adding: NENE01843A.txt (deflated 51%)
  adding: NENE01843B.txt (deflated 51%)
  adding: NENE01978A.txt (deflated 51%)
  adding: NENE01978B.txt (deflated 51%)
  adding: NENE02018B.txt (deflated 51%)
  adding: NENE02040A.txt (deflated 51%)
  adding: NENE02040B.txt (deflated 51%)
  adding: NENE02043A.txt (deflated 51%)
  adding: NENE02043B.txt (deflated 51%)
~~~
{: .output}

We can now verify that these file were added to our ZIP by running `unzip -l` on it:

~~~
unzip -l goodfiles.zip
~~~
{: .language-bash}

~~~
Archive:  goodfiles.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     4406  2017-02-16 15:58   NENE01729A.txt
     4400  2017-02-16 15:58   NENE01729B.txt
     4371  2017-02-16 15:58   NENE01736A.txt
     4411  2017-02-16 15:58   NENE01751A.txt
     4409  2017-02-16 15:58   NENE01751B.txt
     4401  2017-02-16 15:58   NENE01812A.txt
     4395  2017-02-16 15:58   NENE01843A.txt
     4375  2017-02-16 15:58   NENE01843B.txt
     4381  2017-02-16 15:58   NENE01978A.txt
     4389  2017-02-16 15:58   NENE01978B.txt
     3517  2017-02-16 15:58   NENE02018B.txt
     4391  2017-02-16 15:58   NENE02040A.txt
     4367  2017-02-16 15:58   NENE02040B.txt
     4386  2017-02-16 15:58   NENE02043A.txt
     4393  2017-02-16 15:58   NENE02043B.txt
---------                     -------
    64992                     15 files
~~~
{: .output}

## Exercises

> ## Adding and removing files to/from an existing ZIP
> If the `zip` command is run multiple times it will update the files in the
> ZIP and if new files have been specified they will be added. If you run
> a `zip` command multiple times then you will notice on the second/subsequent
> runs it will say "updating" instead of "adding" next to the files which
> already exist in the zip file.
>
> 1. Run the zip command from above (`zip goodfiles.zip NENE*[AB].txt`).
> 2. Repeat the command but change the file name list to `NENE*.txt`. What
> is displayed when the files ending in "Z" are added? How does this differ
> from the other files?
> 3. Verify the files ending in "Z" are now present using `unzip -l`.
> 4. Look at the `zip` man page, how can you now delete the files ending in "Z"
> without rebuilding the entire ZIP file?
> 5. Try the option you just found and verify the result with `unzip -l`.
> 
> > ## Solution
> > ~~~
> > zip goodfiles.zip NENE*[AB].txt
> > zip goodfiles.zip NENE*.txt # should show "updating" next to A/B files and "adding" next to the Z files
> > unzip -l goodfiles.zip # verify the addition
> > zip -d goodfiles.zip NENE*Z.txt # -d deletes files from the zip
> > unzip -l goodfiles.zip # verify the deletion
> > ~~~
> > {: .language-bash}
> {: .solution}
{: .challenge}

> ## Varying the compression level
> You can select the amount/speed of compression applied to a ZIP file when
> creating it. More compression should result in a smaller file but the
> compression (and > decompression) will take longer.
>
> Open the `zip` manpage and find the option which controls the compression
> speed.
>
> Try compressing the text files in the `2012-07-03` directory with
> the different options. What difference does it make to the level of
> compression?
>
> Find out how long it takes to compress at each level by prefixing the `zip`
> command with the `time` command to measure the time the command takes to run
> (this gives three numbers, you want the "real" number), as the files are
> small there will be a lot of variation, so try it a few times.
>
> ~~~
> time zip goodfiles.zip NENE*[AB].txt
> ~~~
> {: .bash}
> 
> > ## Solution
> > The `-0` to `-9` options vary the compression level/speed.
> > `-0` will give no compression, `-9` will give the most and `-6` is the 
> > default. File sizes vary between 66KB with no compression, 35KB at level 1
> > and 34KB beyond level 4. Times (on the author's laptop) vary between 2 and
> > 3 seconds at level 0 to 4-7 seconds at level 9.
> > 
> > The full command will be: 
> > ~~~
> > time zip -9 goodfiles.zip NENE*[AB].txt
> > ~~~
> {: .solution}
{: .challenge}

## Tar archives

An alternative to ZIP archives are Tar archives. Tar stands for "tape archive"
and was originally used to prepare a set of files to be written sequentially
onto a magnetic tape for storage/backup purposes. The Tar command originates
in the Unix world and natively supports Unix file ownership/group information,
symbolic links and permissions.

### Creating a Tar file

Tar files are created and extracted with the `tar` command. To create one we
use the `-c` or `--create` option. The name of the tar file is then specified
with the `-f` or `--file` option. Like with zip we end the command with the
list of files to place inside the archive. For example to make a tar archive
of our "good" files from Nelle's dataset inside the `2012-07-03` we can run:

~~~
tar --create --file goodfiles.tar NENE*[AB].txt
~~~
{: .langauge-bash}

or

~~~
tar -c -f goodfiles.tar NENE*[AB].txt
~~~
{: .language-bash}

or for an even more compact version (note the "f" must be the last argument):

~~~
tar -cf goodfiles.tar NENE*[AB].txt
~~~
{: .language-bash}


Unlike `zip`, `tar` does not give any output to confirm what it has done unless
we add the `-v` or `--verbose` option. This will list the name of every file 
added to our archive.

~~~
tar -cvf goodfiles.tar NENE*[AB].txt
~~~
{: .language-bash}

### Listing the contents of a Tar file

We can list the contents of a Tar by using the `-t` or `--list` option. We must
still use the `-f` or `--file` option to specify the name of the tar file we
are working with.

~~~
tar -tf goodfiles.tar
~~~
{: .language-bash}

If we want an `ls -l` style output the we can add the `-v` or `--verbose` option

~~~
tar -tvf goodfiles.tar
~~~
{: .language-bash}

### Compressing Tar files

Unlike the `zip` command, the `tar` command does not use any compression by
default, instead `tar` files can be compressed by another program. Common
choices for this are `gzip` or `bzip2`, both of which compress a single file
and append a `.gz` or `.bz2` extension on the end. So you will often see tar
files with an extension of `.tar.gz` (sometimes shortened to `.tgz`) or
`.tar.bz2`. Modern versions of `tar` make this easier for us though, they can
take an extra `-z` (or `--gzip`) option for gzip or `-j` (or `--bzip2`) option
for bzip.

~~~
tar -cvjf goodfiles.tar.bz2 NENE*[AB].txt
~~~
{: .language-bash}

### Extracting Tar files

We can extract the contents of a tar file with the `-x` or `--extract` option.
As before this needs to be combined with `-f` or `--files` to specify the file 
name and optionally `-v` or `--verbose` if we want a list of the file names we
are extracting. In older versions of `tar` we needed to add `-z` or `-j` to 
extract a compressed archive, but newer versions will automatically detect this
and do the decompression for us.

~~~
tar -xvf goodfiles.tar.bz2
~~~
{: .language-bash}

> ## Comparing Bzip2, Gzip and Zip compression
> Compress the entire north-pacific-gyre directory using the following formats:
> - Uncompressed Tar
> - Gzip compressed Tar
> - Bzip2 compressed Tar
> - Zip
>
> Make sure you delete any zip/tar files from inside the `2012-07-03` directory
> first.
>
> You will need to find an extra option for `zip` to make it recursively
> archive the directories of `north-pacific-gyre`, look in the man page to
> find this.
>
> Compare the file size for each archiving method. Which is smallest?
> Which is largest?
>
> > ## Solution 
> > ~~~
> > cd ~/ #get back to the home directory, north-pacific-gyre should be a subdirectory of this
> > rm north-pacific-gyre/2012-07-03/*.zip  north-pacific-gyre/2012-07-03/*.tar* # remove any old files
> > tar -cvf north-pacific-gyre.tar north-pacific-gyre
> > tar -cvzf north-pacific-gyre.tar.gz north-pacific-gyre
> > tar -cvjf north-pacific-gyre.tar.bz2 north-pacific-gyre
> > zip -9 -r north-pacific-gyre.zip north-pacific-gyre
> > ls -lh north-pacific-gyre*.*
> > ~~~
> > {: .language-bash}
> >
> > - north-pacific-gyre.tar - 90K
> > - north-pacific-gyre.tar.bz2 - 31K
> > - north-pacific-gyre.tar.gz - 36K
> > - north-pacific-gyre.zip - 41K
> >
> {: .solution}
{: .challenge}

