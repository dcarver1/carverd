---
layout: post
title: "Gone is forever: deleting files in R"
permalink: "gone_forever"
image: forestLake.jpg
tags: [R , tutorial]
categories: R tutorial
---
## I need to delete a lot of things...

My top priority project at the moment involves quantifying the conservation status of plants that are the wild relatives of our modern agricultural crops. These Crop Wild Relatives hold a great deal of genetic diversity that can be breed back into agricultural crops to help improve the crop's ability to withstand challenging conditions such as drought, cold and heat tolerance, and pest resistance.

If this sounds new and interesting, please check out this [video]([https://vimeo.com/166853358](https://vimeo.com/166853358)) by the Crop Trust, which explains the connection between CWRs and modern crops.

My team is currently evaluating the 650 crop wild relatives that are native to the United States. This process involves a lot of input data that is feed into a modeling workflow, which produces a lot of data. The modeling step is an iterative process, meaning there are multiple model runs for each species.

{:refdef: style="text-align: center;"}
![Large background area](/images/goneIsForever/folderStructure.png)
{: refdef}
 > An example of the file structure created for each species for each model run ~ 11 folders per run


{:refdef: style="text-align: center;"}
![files](/images/goneIsForever/capsicumFiles.png)
{: refdef}

> An example of some of the files created on each run. ~ 52 files per run. This process is then applied to 650 species which generates over 7000 file folders and 33,000 files.

Because most of these runs are just tests, they eventually need to be deleted. Deleting all the files by hand would be very cumbersome and time-consuming, so I'm using R to make the computer delete the files for me.

## deleting things with R

As with most computer-related tasks, with a little bit of time and some digging, I was able to find a way to remove all unnecessary files associated with the older model runs efficiently. I relied on the four base R functions to make it happen:
list.dirs()
grep()
list.files()
unlink()
{% highlight R %}
    baseDir <- "D:/cwrNA/gap_analysis"
    allFolders <- list.dirs(path = baseDir, full.names = TRUE, recursive = TRUE)
{% endhighlight %}

I point to the directory where all my files are saved and use `list.dirs()` to gather all file paths within the directory.

> Before deleting old model runs, this directory contain 37,000 sub directories.

{% highlight R %}
    oldFolders <- allFolders[grep(pattern = "test20190827$", x = allFolders)]
{% endhighlight %}

With this list of files, we use the `grep()` function to find all directories that end with "test20190827". Without the "$" at the end of the pattern, the grep function will return all folders that contain the pattern. As we are just deleting files here, it's more efficient to stop at the top directory. If we remove the top directory, we will also capture everything else within it.

{% highlight R %}
    unlink(x = oldFolders[1],recursive = TRUE)
{% endhighlight %}


To start, I just wanted to test the process by deleting a single folder. The `recursive=TRUE` option forces the `unlink()` function to delete file folders. If you are satisfied with the results, you can drop the index and remove all the files.

{% highlight R %}
    unlink(x=oldFolders, recursive = TRUE)
    {% endhighlight %}

This process could be done to catch files from a specific run as well. I needed this because some files are saved with `Sys.Date()` in the name outside of the folders directories which were deleted.

{% highlight R %}
    allFiles <- list.files(path=baseDir, full.names = TRUE, recursive = TRUE)
    #drop the $ because files have extensions
    oldFiles <- allFiles[grep(pattern = "2019-08-27", x = allFiles)]
    # no need for the recursive option as we are working with files only
    unlink(x=oldFiles)
    {% endhighlight %}

# Deleting a lot of things with R

While this process is much much faster than manually deleting files, I still have a lot of things to delete. Let's say I ran the modeling process four days in a row, but I only need to keep the 4th iteration. We can automate this process a bit more by wrapping the process into a function and rolling it across a list.

{% highlight R %}
    # function for deleting a lot of files
    deleteALot <- function(directory,pattern){
      allFolders <- list.dirs(path = directory, full.names = TRUE, recursive = TRUE)
      oldFolders <- allFolders[grep(pattern = "test20191206$", x = allFolders)]
      unlink(x = oldFolders, recursive = TRUE)
      print(paste0("All files and folders containing ", pattern, " are gone forever."))
    }
    # generate a list of patterns
    listOfPatterns <- c("test20191206$","test20191207$","test20191208$")

    # loop over the patterns and delete A Lot
    for(i in listOfPatterns){
      deleteALot(directory = "D:/cwrNA/gap_analysis/temp", pattern = i)
    }
    {% endhighlight %}

## With great power comes great responsibility

I worked with a co-instructor at a summer camp where we could take grade school kids out in canoes and kayaks on lakes. While teaching skills and safety on land, he would frequently tell the kids that "Gone is forever." A warning that anything the drop beneath the surface of the water was unrecoverable, lost, and completely gone from your life, forever.
It was a dire warning to attempt to create some sense of responsibility in the kids, and the advice applies to this process as well. The `unlink()` function does not move items to the recycling bin; it removes them from your computer. They are not coming back. Be cautious and think before you unlink.
