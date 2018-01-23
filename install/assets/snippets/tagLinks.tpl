<?php
/**
 * tagLinks
 *
 *  Gets the tags for the current page (if any are set)
 *
 * @category  Content
 * @version   1.0.5
 * @license   GNU General Public License (GPL), http://www.gnu.org/copyleft/gpl.html
 * @author Scotty Delicious <scottydelicious@gmail.com>
 *
 * @example
 *  on a page:    [[tagLinks? &tv=`documentTags` &separator=`, ` &path=`50`]] // 50 is the ID of your tags landing page
 *  on doclister tpl: [[tagLinks? &id=`[+id+]` &value=`[+documentTags+]` &separator=`, ` &path=`50`]] 
 */

/**
* Parameters:
* &id = document id to get tags for. default is
*       current document.  When using this in a
*       ditto tpl, use &id=`[+id+] to get the tags
*       for the document being summarized.
*
* &tv = name of the template variable used for
*       setting categories.
*
* &value = value of the tv if it has already
*		been retrieved
*
* &delimeter = delimiter used in the tv.
*       defaults to a comma ","
*
* &caseSensitive = remove tags that are the
* 		same word but were written using different
* 		cases. defaults to false.
*
* &label = Label listed before the list of links.
*       defaults to "Categories: ".
*
* &separator = character to separate tag links.
*       comma (,) or pipe (|) for example.
*       defaults to '' (blank).
*
* &element = Element to wrap this in [div/span/p].
*       defaults to "div".
*
* &style = CSS tag to apply to the &element.
*       defualts to "taglinks".
*
* &format = format of the output for links. can be an
*       anchor `a`, unordered list `ul`, or an ordered
*       list `ol`
*
* &newline = add new line after each element.
*       defaults to '1' (yes, add new lines).
*       set to `0` and new lines will not be added.
*
* &path = path to your categories page. if your
*       category pages are under "yoursite.url/blog/categories/",
*       you would set &path=`blog/categories`. 
*		Alternatively, supply a doc ID number, and it will
* 		be converted to a path automagically.
*
***************************************/

/**
* Set values for items that were not set in the
* snippet call.
*/
$page_id = isset($id) ? $id : $modx->documentObject['id'];
$tv = isset($tv) ? $tv : '';
$delimiter = isset($delimiter) ? $delimiter : ',';
$label = isset($label) ? $label : 'Categories: ';
$separator = isset($separator) ? $separator : '';
$element = isset($element) ? $element : 'div';
$style = isset($style) ? $style : 'taglinks';
$format = isset($format) ? $format : 'a';
$newline = isset($newline) ? $newline : '1';
$path = isset($path) ? $path : '';
$caseSensitive = isset($caseSensitive) ? $caseSensitive : 0;

// If a numeric path is supplied, assume it is a modx page ID, so create a URL from it
if (!empty($path) && is_numeric($path)) {
	$path = $modx->makeUrl($path);	
}

// Do we need to make the URL ampersands XHTML compatible?
$amp = $modx->config['xhtml_urls'] == '1'?'&amp;':'&';

/**
* Get the tags from the TV the user supplied
*/
if ($tv == '' && !isset($value)){return "No template variable for tags was declared.";}
$get_tags = isset($value) ? $value : implode($delimiter,$modx->getTemplateVarOutput($idname=array($tv), $page_id, $published="1"));

/**
* Make an array of all the tags associated with the specified document.
*/
$tags = array();
$tvarray = explode($delimiter, $get_tags);
foreach ($tvarray as $tag) {
	if (!empty($tag)) {
		if ($caseSensitive) {
			$tags[trim($tag)] = trim($tag);
		} else {
			$tags[strtolower(trim($tag))] = trim($tag);
		}
	}
}
$tvarray = array_values($tags);
$cnt = count($tvarray);

/**
* Build the URL
*/
$url_seperator = (strpos($path, '?') === false)?'?':$amp;
$doc_path = $path.$url_seperator.'tags=';


/**
* Remove new lines if &newline is set to `0`.
*/
if ($newline == '1'){
	$nl = "\n";
} else {
	$nl = '';
}

/**
* Create the containing element (<div>, <span>, or <p>)
* and give it the style declared in &style.
*/
$link .= '<'.$element.' class="'.$style.'">'.$nl;

/**
* Create a series of HTML anchors with hrefs if &format
* is set to `a`.
*/
if ($format == 'a'){
$link .= "$label";
	for ($x=0;$x<$cnt;$x++) {
		$url = urlencode(trim($tvarray[$x]));
		$cnd_separator = ($x!=($cnt-1)) ? $separator : '';
	   $link .= '<a href="'.$doc_path.strtolower($url).'">'.trim($tvarray[$x]).'</a>'.$cnd_separator.$nl;	
	}
} else {

/**
* Otherwise genereate a series of list items with a hrefs if &format
* is set to ordered or unordered list.
*/
	$link .= '<'.$format.'>'.$nl;
	$link .= '<li class="'.$style.'_label">'.$label.'</li>'.$nl;
	for ($x=0;$x<$cnt;$x++) {
		$url = urlencode(trim($tvarray[$x]));
		$cnd_separator = ($x!=($cnt-1)) ? $separator : '';
	   $link .= '<li><a href="'.$doc_path.strtolower($url).'">'.trim($tvarray[$x]).'</a>'.$cnd_separator.'</li>'.$nl;
	}
	$link .= '</'.$format.'>'.$nl;
}

/**
* Close the containing element.
*/
$link .= '</'.$element.'>'.$nl;

/**
* If the array is empty (because no tags were attached to the document)
* return nothing as to not disturb the page layout.
*/
if ($tvarray['0'] == ''){
	return;
}else{

/**
* Otherwise return the links to the page!
*/
return $link;
}
