# Doclister Tags in Ditto Style
Tutorial and resources to replace Ditto Blog tags with Doclister

## Goals
* Create a Blog like in Ditto, with tags
* Create a Tags Landing page like Ditto with DocLister
* Tags URLS like Ditto: 100% compatible with TagLings and TvTagCloud snippets. ie:  ```&tags=```
* Display tags in Doclister item
* Display tags on (item) page

# Inspirations: 
* https://github.com/evolution-cms/evolution/issues/176
* https://github.com/evolution-cms/evolution/issues/451
* solution by [@pmfx](https://github.com/pmfx) https://github.com/evolution-cms/evolution/issues/176#issuecomment-325036799

## Included Extras
* **DLlandingTags** snippet: based on [run_doclister_blog](https://gist.github.com/pmfx/bef18541b1835d0855ececf231fa973d) by @pmfx - renamed, added tagTV parameter, tags placeholder, more dl params and improved to fit ditto tags url parameters (&tags=)
* **DLlandingTags** snippet: based on [run_doclister_itemTags](https://gist.github.com/pmfx/66da4628fbfd34d7a7d4019d70287c07) by @pmfx - just renamed 
* **taglinks** https://modx.com/extras/package/taglinks
* **TvTagCloud** https://github.com/extras-evolution/TvTagCloud


# Create a Doclister Blog like in Ditto or Update your old Ditto Blog to Doclister

#### NOTE: the tutorial is based and tested on evolution 1.4 demo content

## 1) Blog Page (id 2)

**Doclister example call** for the main Blog Page

Note: **tag tv**: documentTags

```
[[DocLister? 
	&jotcount=`1`
	&parents=`2` 
	&display=`2`
	&tvPrefix=``
	&tvList=`image,documentTags`
	&prepare=`prepareBlog`
	&summary=`notags,len:350` 
	&paginate=`pages` 
	&extender=`user` 
	&usertype=`mgr` 
	&userFields=`createdby,publishedby` 
	&tpl=`blogTPL` 
]]

<p>Showing <strong>[+current+]</strong> of <strong>[+totalPages+]</strong> Pages</p>
[+pages+]
```
#### Ditto-like pagination
Setting **&paginate** to **offset** ``` &paginate=`offset` ``` enable ditto-like pagination mode with url parametrs like Ditto: ```blog.html?start=2``` instead ```blog.html?page=2``` like use Doclister.

credits [Pathologic](https://github.com/Pathologic) : https://github.com/evolution-cms/evolution/issues/176#issuecomment-326279720 

**This will avoid 404 errors with pagination when updating an old Ditto Blogs** 



## 2) blogTPL

```
<div class="dl_summaryPost">
			[+blog-image+]	
			<h3><a href="[~[+id+]~]" title="[+e.title+]">[+e.title+]</a></h3>
			<div class="dl_info">
				By <strong>[+user.username.createdby+]</strong> on [+date+].
				<a href="[+url+]#commentsAnchor">Comments <span class="badge">[+jotcount+]</span></a>
			</div>
			[+summary+]
			<p class="dl_link">[+link+]</p>
		</div>
```
![blogtpl1](https://user-images.githubusercontent.com/7342798/35296125-5a305916-007b-11e8-8c0f-4c0636cf0ba2.png)


## 3) Now... The Tag Landing page

* Install [DLlandingTags snippet](https://github.com/Nicola1971/Doclister-Tags-in-Ditto-Style/blob/master/install/assets/snippets/DLlandingTags.tpl)
* **DLlandingTags** for the Tag Landing page

### Add to your new tag landing page (ie: id 50)
```
[[DLlandingTags? &parents=`0` &paginate=`1` &tpl=`blogTPL` &tagTV=`documentTags` &display=`10` &depth=`4` &tvList=`image,documentTags`]]
```
I've added to **DLlandingTags** the **tags** placeholder so you can output the current tag in longtitle or other field, like in the old fashioned way :smile:

![tags](https://user-images.githubusercontent.com/7342798/35295722-2eca1056-007a-11e8-9202-409b00875022.png)

![tag-landing](https://user-images.githubusercontent.com/7342798/35296256-cb3a15f2-007b-11e8-897b-b10b3e9e4963.png)

## 4) Add tags to blogTPL

Note: **id of Tag Landing page**: 50

#### Method 1) 
With [DLitemTags](https://github.com/Nicola1971/Doclister-Tags-in-Ditto-Style/blob/master/install/assets/snippets/DLitemTags.tpl)

```
<div class="dl_summaryPost">
			[+blog-image+]	
			<h3><a href="[~[+id+]~]" title="[+e.title+]">[+e.title+]</a></h3>
			<div class="dl_info">
				By <strong>[+user.username.createdby+]</strong> on [+date+].
				<a href="[+url+]#commentsAnchor">Comments <span class="badge">[+jotcount+]</span></a> Tags: [[DLitemTags? &id=`tags` &tags=`[+documentTags+]` &tagsLanding=`50`]]
			</div>
			[+summary+]
			<p class="dl_link">[+link+]</p>
		</div>
```
#### Method 2) 
With [tagLinks](https://github.com/Nicola1971/Doclister-Tags-in-Ditto-Style/blob/master/install/assets/snippets/tagLinks.tpl)

```
<div class="dl_summaryPost">
			[+blog-image+]	
			<h3><a href="[~[+id+]~]" title="[+e.title+]">[+e.title+]</a></h3>
			<div class="dl_info">
				By <strong>[+user.username.createdby+]</strong> on [+date+].
				<a href="[+url+]#commentsAnchor">Comments <span class="badge">[+jotcount+]</span></a> [[tagLinks? &id=`[+id+]` &value=`[+documentTags+]` &separator=`, ` &path=`50` &label=`Tags: `]]
			</div>
			[+summary+]
			<p class="dl_link">[+link+]</p>
		</div>
```
![blogtpl2](https://user-images.githubusercontent.com/7342798/35296150-6ee8d55e-007b-11e8-9f43-1099f3cb43bb.png)

# More 

## Add tags on the page
* With [tagLinks](https://github.com/Nicola1971/Doclister-Tags-in-Ditto-Style/blob/master/install/assets/snippets/tagLinks.tpl)
```
[[tagLinks? &tv=`documentTags` &separator=`, ` &path=`50` &label=`Tags: `]]
```
![tags-onpage](https://user-images.githubusercontent.com/7342798/35296349-099b9f28-007c-11e8-9b43-a5c751207454.png)

## Add a Tag Cloud to the sidebar
* With [tvtagcloud](https://github.com/Nicola1971/Doclister-Tags-in-Ditto-Style/blob/master/install/assets/snippets/tvtagcloud.tpl)
```
[[TvTagCloud? &parent=`2` &landing=`50` &tvTags=`documentTags` &showCount=`0`]]
```
![tagcloud](https://user-images.githubusercontent.com/7342798/35296362-1a1a8ef4-007c-11e8-9939-124521ab22e4.png)

# The End :)
