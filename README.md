# Doclister Tags in Ditto Style
Tutorial and resources to replace Ditto Blog tags with Doclister

# inspirations: 
* https://github.com/evolution-cms/evolution/issues/176
* https://github.com/evolution-cms/evolution/issues/451
* solution by [@pmfx](https://github.com/pmfx) https://github.com/evolution-cms/evolution/issues/176#issuecomment-325036799

## Included Extras
* **DLlandingTags** snippet: based on [run_doclister_blog](https://gist.github.com/pmfx/bef18541b1835d0855ececf231fa973d) by @pmfx - renamed, added tagTV parameter, more dl params and improved to fit ditto tags url parameters (&tags=)
* **DLlandingTags** snippet: based on [run_doclister_itemTags](https://gist.github.com/pmfx/66da4628fbfd34d7a7d4019d70287c07) by @pmfx - just renamed 
* **taglinks** https://modx.com/extras/package/taglinks
* **TvTagCloud** https://github.com/extras-evolution/TvTagCloud

## Goals
* Create a Blog like in Ditto, with tags
* Create a Tags Landing page like Ditto with DocLister
* Tags URLS like Ditto: 100% compatible with TagLings and TvTagCloud snippets. ie:  ```&tags=```
* Display tags in Doclister item
* Display tags on (item) page

# Create a Doclister Blog like in Ditto or Update your old Ditto Blog to Doclister

#### NOTE: the tutorial is based and tested on evolution 1.4 demo content

## 1) Blog Page

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
	&tvPrefix=`` 
	&paginate=`offset` 
	&extender=`user` 
	&usertype=`mgr` 
	&userFields=`createdby,publishedby` 
	&tpl=`blogTPL` 
	&paginate=`1` 
]]

<p>Showing <strong>[+current+]</strong> of <strong>[+totalPages+]</strong> Pages</p>
<div id="dl_pages">[+pages+]</div>
<p>&nbsp;</p>
```
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

## 3) Now... The Tag Landing page

* Install [DLlandingTags snippet](https://github.com/Nicola1971/Doclister-Tags-in-Ditto-Style/blob/master/install/assets/snippets/DLlandingTags.tpl)
* **DLlandingTags** for the Tag Landing page
```
[[DLlandingTags? &parents=`0` &paginate=`1` &tpl=`blogTPL` &tagTV=`documentTags` &display=`10` &depth=`4` &tvList=`image,documentTags`]]
```


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
				<a href="[+url+]#commentsAnchor">Comments <span class="badge">[+jotcount+]</span></a> [[tagLinks? &id=`[+id+]` &value=`[+documentTags+]` &separator=`, ` &path=`50`]]
			</div>
			[+summary+]
			<p class="dl_link">[+link+]</p>
		</div>
```


# More 

## Add tags on the page
* With [tagLinks](https://github.com/Nicola1971/Doclister-Tags-in-Ditto-Style/blob/master/install/assets/snippets/tagLinks.tpl)
```
[[tagLinks? &tv=`documentTags` &separator=`, ` &path=`50`]]
```
## Add a tags cloud
* With [tvtagcloud](https://github.com/Nicola1971/Doclister-Tags-in-Ditto-Style/blob/master/install/assets/snippets/tvtagcloud.tpl)
```
[[TvTagCloud? &parent=`2` &landing=`50` &tvTags=`documentTags` &showCount=`0`]]
```
