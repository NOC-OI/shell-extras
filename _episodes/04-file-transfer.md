---
title: "Transferring Files"
teaching: 15
exercises: 10
questions:
- "How to use Wget, curl and rsync to transfer file?"
objectives:
- "To know different ways to interact with remote files"
keypoints:
- "`wget` is the default tool, available in most Linux distributions,
to download files from web and FTP servers."
- "`curl` is another utility for downloading remote webpages.
It defaults to outputting the result on screen, this can be piped to other
programs."
- "`rsync` is a utility for transferring files. It can use the SSH protocol and
is useful for mirroring complicated directory structures from one computer to
another."
---

There are other ways to interact with remote files other than scp.

## Wget

Wget is a simple tool developed for the GNU Project that downloads files with
the HTTP, HTTPS and FTP protocols. It is widely used by Unix-like users and
is available with most Linux distributions.

To download this lesson (located at
<{{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html>)
from the web via HTTP we can simply type:

~~~
$ wget {{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html
~~~
{: .language-bash}

~~~
--2021-05-29 02:12:18—
{{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html
Resolving carpentries-incubator.github.io (carpentries-incubator.github.io)... 185.199.111.153, 185.199.110.153, 185.199.109.153, ...
Connecting to carpentries-incubator.github.io (carpentries-incubator.github.io)|185.199.111.153|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22467 (22K) [text/html]
Saving to: ‘index.html’
index.html        100%[===================>]  21.94K  --.-KB/s    in 0.003s

2021-05-29 02:12:19 (6.35 MB/s) - ‘index.html’ saved [22467/22467]
~~~
{: .output}

Alternatively, you can add more options, which are in the form:

~~~
wget -r -np -D domain_name target_URL
~~~
{: .language-bash}

where `-r` means recursively crawl to other files and directories, `-np` means
avoid crawling to parent directories, and `-D` means to target only the
following domain name

For our URL it would be:

~~~
$ wget -r -np -D carpentries-incubator.github.io {{ site.url }}{{ site.baseurl }}
~~~
{: .language-bash}

To restrict retrieval to a particular extension(s)
we can use the `-A` option followed by a comma separated list:

~~~
wget -r -np -D carpentries-incubator.github.io -A html {{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html
~~~
{: .language-bash}

We can also clone a webpage with its local dependencies:

~~~
$ wget -mkq target_URL
~~~
{: .language-bash}

We could also clone the entire website:

~~~
$ wget -mkq -np -D domain_name domain_name_URL
~~~
{: .language-bash}

and add the `-nH` option if we do not want a subdirectory created for the websites content:

e.g.

~~~
$ wget -mkq -np -nH -D example.com http://example.com
~~~
{: .language-bash}

where:

`-m` is for mirroring with time stamping, infinite recursion depth, and preservation of FTP directory settings
`-k` converts links to make them suitable for local viewing
`-q` supresses the output to the screen

The above command can also save the clone the contents of one domain to another
if we are using ssh or sshfs to access a webserver.

Please refer to the man page by typing `man wget` in the shell for more information.

## cURL

Alternatively, we can use `cURL`.
It supports a much larger range of protocols including common mail based protocols like pop3 and smtp.

To download this lesson (located at {{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html)
from the web via HTTP we can simply type:

~~~
$ curl -o index.html {{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html
~~~
{: .language-bash}

~~~
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
100 14005  100 14005    0     0  35170      0 --:--:-- --:--:-- --:--:--  105k
~~~
{: .output}

This input to curl is in the form:

~~~
curl -o filename_for_local_machine target_url
~~~
{: .language-bash}

where the `-o` option says write the output to a file instead of the stdout
(the screen), and file_name_for_local_machine is any file name you choose to
save to the local machine, and target_URL is where the file is the URL where
the file is on the web.

Removing the `-o` option, and following the syntax `curl target_URL`
outputs the contents of the url to the screen.
If we wanted to enhance the functionality we have we could use information
from the pipes and filters section, which is lesson 4 from the unix shell session.

For example, we could type
`curl {{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html | grep curl`
which would tell us that indeed this URL contains the string curl.
We could make the output cleaner by limiting the output of curl to just the
file contents by using the `-s` option
(e.g. `curl -s {{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html | grep curl`).

If we wanted only the text and not the html tags in our output we could use
html to text parser such as `html2text`.

~~~
$ curl -s {{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html | html2text | grep curl
~~~
{: .language-bash}

With `wget`, we can obtain the same results by typing:

~~~
$ wget -q -D carpentries-incubator.github.io -O /dev/stdout {{ site.url }}{{ site.baseurl }}/04-file-transfer/index.html | html2text | grep curl
~~~
{: .language-bash}

`wget` offers more functionality natively than `curl` for retrieving entire
directories. We could use `wget` to first retrieve an entire directory and
then run `html2text` and `grep` to find a particular string.
`cURL` is limited to retrieving one or more specified URLs that cannot be
obtained by recursively crawling a directory. The situation may be improved by
combining with other unix tools, but is not thought as being as good as `wget`.

Please refer to the man pages by typing `man wget`, `man curl`, and
`man html2text` in the shell for more information.

> ## Continuing a stopped download
> Start a download of a large file (e.g.
> https://www.zenodo.org/record/5307070/files/S-only-10000x.tar.gz, a file from
> a dataset of simulated wastewater sequencing data for SARS-CoV-2
> using Wget and stop the download before it has finished by pressing the
> 'ctrl' and 'c' keys together. This will leave a partially downloaded file on
> your computer.
>
> Open the Wget man page by running `man wget` and find the option to continue
> a partial download.
>
> Resume your download with this option.
>
> > ## Solution
> >The -c or --continue option will tell Wget to resume a partial download.
> > ~~~
> > wget -c https://www.zenodo.org/record/5307070/files/S-only-10000x.tar.gz
> > ~~~
> > {: .language-bash}
> {: .solution}
{: .challenge}

> ## Download an additional dataset for Nelle
> Nelle has another dataset to process from July 4th 2012.
> It is located online at {{site.url}}{{ site.baseurl }}/data/north-pacific-gyre-2012-07-04.zip.
> Login to a remote system over SSH and download this file on there using
> either Wget or cURL. Then extract the data from this file using the `unzip`
> command.
>
> > ## Solution
> > ~~~
> > ssh nelle@neptune.aquatic.edu
> > wget {{ site.url }}{{ site.baseurl }}/data/north-pacific-gyre-2012-07-04.zip
> > unzip north-pacific-gyre-2012-07-04.zip
> > ~~~
> > {: .language-bash}
> {: .solution}
{: .challenge}

## Rsync

Rsync is a utility for synchronising directories between computers (and on the
same computer). It can use the SSH protocol for copying to a remote computer
but also has it's own (less commonly used) file transfer protocol.

### Rsync Syntax
The -a option to rsync specifies that we want to use "archive" mode, which will
set several other options to make the copy mirror the names and permissions
of the source directory. The -v option enables verbose mode to tell us more
about what is being copied. To use rsync over ssh we need to specify "-e ssh".
Finally we give the source and destination directories, just like the cp or scp
command.

~~~
rsync -a -v -e ssh 04-file-transfer nelle@neptune.aquatic.edu:
~~~
{: .language-bash}

### Why use rsync instead of scp?
Rsync only transfers files (or parts of files) if they don't exist in the
destination directory. This means that if a transfer is stopped for any reason,
when you resume it won't copy things that were already copied. Scp does not do
this and will start the transfer again. If you are copying large files that
take many days/hours there is a chance your transfer might be interrupted at
some point and you don't want to have to repeat what you've already done when
resuming it.

{% include links.md %}
