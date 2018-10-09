Linkedin Post

Teaching, Learning, and Markdown?

I read this quick article today by because the "Feynman Technique" interested me. Feynman is a well know and rather eccentric physicist who is respected for his advancement of the field as well as his ability to communicate science to those learning it. The "Feynmen lectures" written in 1959 are still a dependable resource for those clawing through their introductory physics coursework. Considering this individuals role in science communication, I felt that this Feynman Technique could be a worth while framework.

Check out the full article [here](https://towardsdatascience.com/want-to-become-a-data-scientist-try-feynman-technique-2ea010da1c54)

The basic framework is as follows
1. Spend time developing a personal understanding on the topic
2. explain the process as if your teaching
3. Demonstrate processes through examples
4. Reassess personal understanding

There is nothing crazy about this process. Learn, explain, show, and evaluate. If you've worked in the educational field at all this sounds like a bread and butter process. So Feynman is famous and I don't know when this technique was push out to the world but I doubt that he has been the only person to independently claim that teaching is an essential part of the learning process. Details aside, this technique seems important and I believe it can be brought in most workflows.  

At the same time, how often do we follow through with that connection between teaching and learning. I personally know I hear the idiom "Those who can, do; those who can't, teach" more then "Teaching is an integral aspect of the learning process". So if it seems obvious to you the reality is that connection is by no means obvious to everyone.

Ok, to try it back to something a bit more tangible. At this point in time, I write a lot of code. I use code to connect data to ideas. Those ideas are then transferred to those who don't have the time or interest to complete that middle step themselves. So what real incentive due I have to "explain or demonstrate" how I got to the end product when the reason I'm working is to cover that middle step for someone else?

At this point, I think that personal motivation is really enough. It's enough because extending your code to incorporate an explaining and demonstrating component is easy when you write in markdown.

### Everyday code

Here is a section of code that is commented out well a general understanding and application.

```(python)
# function that gathers the extent information from a raster
def extents(fc):
    """
    This function takes in an arcpy object and returns the spatial extent features
    """
    extent = arcpy.Describe(fc).extent
    west = extent.XMin
    south = extent.YMin
    east = extent.XMax
    north = extent.YMax
    width = extent.width
    height = extent.height
```
Based on your own background this process may make more or sense to you. So it's usable but we don't add anything to the explaining and demonstrating aspect of the work. So we learn it our self but as Feynman suggest, that's a shallow level of understanding.
Here is where Markdown can help a but.

1. Plain Text Commits
 - Here is the same code that is filled in a bit
We want a reproducible segment of code that allows use to get information about the spatial extent of a raster that we read in.  

```{python}
# function that gathers the extent information from a raster
def extents(fc):
    """
    This function takes in an arcpy object and returns the spatial extent features
    """
    extent = arcpy.Describe(fc).extent
    west = extent.XMin
    south = extent.YMin
    east = extent.XMax
    north = extent.YMax
    width = extent.width
    height = extent.height
```
Nothing significant changes here. The code is still present and commented as one hope it would be. What is really diffent if the frame of the process with plan text. This fits into step two of the feynman process, explain. Markdown makes it easy to add these bits of extra content that make your document more explainatory.

2. providing links and example code that does not run
 - example

To answer our question we really only need to know the upper left corner of the raster feature. So we could use the full function that we've created or just pull a piece from it.

This code will not be executed it will just show up in the document.
```python
# function that gathers the extent information from a raster
def extents(fc):
    """
    This function takes in an arcpy object and returns the spatial extent features
    """
    extent = arcpy.Describe(fc).extent
    west = extent.XMin
    south = extent.YMin
    east = extent.XMax
    north = extent.YMax
    width = extent.width
    height = extent.height
```
So lets rework the function a bit to just pull the information we need.

```python
def extentsLite(fc):
    """
    This function takes in an arcpy object and returns the upper left corner
    """
    extent = arcpy.Describe(fc).extent
    west = extent.XMin
    north = extent.YMax
    upperLeft = [west,north]
    return(upperLeft)
```
By incorporating non exicuting aspects of the code you can help to understand the decission making behind your process. Markdown makes it easy to bring this information and decide if you want to show it our not. The deal it we all make changes and alterations to our scripts as were developing them. Those decisions add to out owen learning process and can help other understand our methods as well. For the most part we detail those from our code and slowly forget about them overtime. By incorporating sections on non exacutable code with plain text comments we can easily hold on to those extra bits and peices.

3. pulling in imagery and links as examples
Probably the most impacts component of writing in markdown is the ease at which you can incorperate imagery and external links. My farvorite example of this comes from thinking out my use of stack exchange. You search the site for an approach to your questions and often find one. Give that post a up vote and throw the link into your document. This is kinda like a reference in a academic paper. We grow fast by building off other and I think giving them credit instentaly provide other looking at your work a more complete picture of where this method came from.

**include as link to the reference for the code chunk I was looking at.**
**Through an annotated image in as well to get the idea across**

I understand that markdown is not really going to work for everyone. Jupyter notebooks really seem to be the option that most people are going for. Pick your cup of tea. At the end of the day this is about getting more out of your work. If you can teach your content you understand it more completely. Increase your understanding and you will enjoy your work more and be better able to speak to your abilities. So while Feynman probably didn't spend much time writing in markdown, I think he would respect your effort to make more approachable.

*I would saw this is almost done, Maybe it better to use an r code segment, maybe not right now the formating it off. Either way i think it's best to find a different code chuck to highlight
