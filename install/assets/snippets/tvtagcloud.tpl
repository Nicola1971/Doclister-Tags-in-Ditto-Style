//<?php
/**
 * TvTagCloud
 * 
 * Displays the tags from set of documents in a "tag cloud" or list
 *
 * @category 	snippet
 * @version 	2.2
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal	@properties
 * @internal	@modx_category Navigation
 * @internal    @installset base, sample
 */

/****************************************************
* Credits:
*   Created by Kyle Jaebker and optimized by Mark Kaplan
*   Style code added by Garry Nutting
*   Large parts refactored and features added by Nick Crossland
*   dittoID added by Jens Weintraut
* 	numeric sorting and limit (top) code by BBloke
*   Based of code by Marc Hinse, mh@madeyourweb.com, www.modxcms.de (original TagCloud creator)


USAGE

[!TvTagCloud? &parent=`1` &landing=`22` &tvTags=`docTags` &showCount=`1`!]


REQUIRED PARAMETERS

	parent: folder that contains the documents which are to be counted. Can take a comma separated list of parents, like Ditto does.
	 
	tvTags: the template variable that has the tags
	
	
OPTIONAL PARAMETERS	

	depth: the number of levels down we should search for child documents
	
	days: the number of days to look back over to find tags. Leave as 0 for all time
	
	min: minimum number of tag occurances for tag to show, 0 for all
	
 	sort: how should the results be ordered? By default they will be sorted by document ID. Values can be:
			asc - tag alphabetical
			dec - tag reverse alpgabetical
			numasc - tag count ascending
			numdesc - tag count descending
			random - random order
			
	landing: id of document to display ditto listings
   
	tagDelim: delimiter between tags in TV
   
	displayType: [cloud | list | custom] output as a tag cloud, unordered list, or custom output. If custom output, specify a chunk name via customDisplayChunk

	customDisplayChunk: chunk name containing HTML when displayType = custom. Uses the following placeholders: [+class+] [+landing+] [+qs_seperator+] [+url_param+] [+tag+] [+urlencoded_tag+] [+tooltip+] [+count+] [+bracketed_count+]

	showCount: if you want the number of occurances to be displayed set to 1

	caseSensitive: if you want tag duplicate removal to be case sensitive set to 1

	steps: comma separated list of the numeric intervals to determine the size of the tag class
	
	styles: comma separated list of class names that will be applied to each of the size intervals in "steps"

	dittoID: Id of the Ditto instance which should display the selected tag (if there is more than one Ditto call on landing page)

	limit: restrict the number of tags to display
	
	exclude: list of tags you don't want to appear in the output (separated by tagDelim - a comma by default)
	
	promote: list of tags you want to appear first in the output (separated by tagDelim - a comma by default)
	
	demote: list of tags you want to appear last in the output (separated by tagDelim - a comma by default)
 	
	extraTags: list of extra tags you want to appear, even if they're not detected in the pages (separated by tagDelim - a comma by default)
 	
	currentClass: class name to apply to the tag which is currently being filtered on
 	
	urlParam:	name of the URL parameter used when generating URLs or detecting filtering
	
	

Landing Page setup:
   the landing page should have a call to ditto (v2+) with at
   minimum the following tagging parameters set:

   [!Ditto? &parents=`1` &extenders=`tagging` &tagData=`docTags` &tagDelimiter=`,`!]


* ***************************************************/

$parent = isset ($parent) ? $parent : "0";
$depth = isset ($depth) ? $depth : 10;
$days = isset ($days) ? $days : 0;
$min = isset ($min) ? $min : 0;
$sort = isset ($sort) ? strtolower($sort) : false;	// asc, desc, or random
$landing = isset ($landing) ? $landing : "[*id*]";
$tvTags = isset ($tvTags) ? $tvTags : 'repo_tags';
$tagDelim = isset ($tagDelim) ? $tagDelim : ',';
$displayType = isset ($displayType) ? $displayType : 'cloud';
$customDisplayChunk = isset ($customDisplayChunk) ? $customDisplayChunk : '';
$showCount = isset ($showCount) ? $showCount : 0;
$caseSensitive = isset ($caseSensitive) ? $caseSensitive : 0;
$steps = isset($steps) ? $steps : '14,25,34,51,100';
$styles = isset($styles) ? $styles : 's5,s4,s3,s2,s1';
$dittoID = isset($dittoID) ? $dittoID . '_' : '';
$limit = isset ($limit) ? $limit : 0;
$exclude = isset ($exclude) ? explode($tagDelim, $exclude) : array();
$promote = isset ($promote) ? explode($tagDelim, $promote) : array();
$demote = isset ($demote) ? explode($tagDelim, $demote) : array();
$extraTags = isset ($extraTags) ? explode($tagDelim, $extraTags) : array();
$currentClass = isset ($currentClass) ? $currentClass : 'current';
$urlParam =  isset ($urlParam) ? $urlParam : 'tags';

//-- styles for different sizes in the tag cloud (smallest to largest)
$steps = explode(',', $steps);
$styles = explode(',', $styles);






/* -------------------------------- Functions -------------------------------- */


/* ---------------- getTags ---------------- */
if (!function_exists('getTags')) {
	function getTags($cIDs, $tvTags, $days) {
		
		global $modx, $parent;
		
		$docTags = array ();

		$baspath= MODX_MANAGER_PATH . "includes";
	    include_once $baspath . "/tmplvars.format.inc.php";
	    include_once $baspath . "/tmplvars.commands.inc.php";
		
		if ($days > 0) {
			$pub_date = mktime() - $days*24*60*60;
		} else {
			$pub_date = 0;
		}
		
		$tb1 = $modx->getFullTableName("site_tmplvar_contentvalues");
		$tb2 = $modx->getFullTableName("site_tmplvars");
		$tb_content = $modx->getFullTableName("site_content");
		$query = "SELECT stv.name,stc.tmplvarid,stc.contentid,stv.type,stv.display,stv.display_params,stc.value";
		$query .= " FROM ".$tb1." stc LEFT JOIN ".$tb2." stv ON stv.id=stc.tmplvarid ";
		$query .= " LEFT JOIN $tb_content tb_content ON stc.contentid=tb_content.id ";
		$query .= " WHERE stv.name='".$tvTags."' AND stc.contentid IN (".implode($cIDs,",").") ";
		$query .= " AND tb_content.pub_date >= '$pub_date' ";
		$query .= " AND tb_content.published = 1 ";
		$query .= " ORDER BY stc.contentid ASC;";
		
		$rs = $modx->db->query($query);
		$tot = $modx->db->getRecordCount($rs);
		$resourceArray = array();
		for($i=0;$i<$tot;$i++)  {
			$row = @$modx->fetchRow($rs);
			$docTags[$row['contentid']]['tags'] = getTVDisplayFormat($row['name'], $row['value'], $row['display'], $row['display_params'], $row['type'],$row['contentid']);   
		}
		if ($tot != count($cIDs)) {
			$query = "SELECT name,type,display,display_params,default_text";
			$query .= " FROM $tb2";
			$query .= " WHERE name='".$tvTags."' LIMIT 1";
			$rs = $modx->db->query($query);
			$row = @$modx->fetchRow($rs);
			$defaultOutput = getTVDisplayFormat($row['name'], $row['default_text'], $row['display'], $row['display_params'], $row['type'],$row['contentid']);
			foreach ($cIDs as $id) {
				if (!isset($docTags[$id]['tags'])) {
					$docTags[$id]['tags'] = $defaultOutput;
				}
			}
		}
		
			return $docTags;
	}
	

}





/* -------------------------------- Main section -------------------------------- */


// Get the subentities of the supplied parent
$parents = explode(',',$parent);
$subEntities = $parents;
foreach ($parents as $parentDoc) {
	$subDocs = $modx->getChildIds($parentDoc, $depth);
	$subEntities = array_merge($subDocs,$subEntities);
}

$docTags = getTags(array_unique($subEntities), $tvTags, $days);
// docTags now contains an array indexed by docId, with each value containing an array of tags, e.g.:



// go through each document, split the works into an array, and add them to a 
// master array with the word as the key, and a value containing an array consisting of count and style name
$tags  = array();
$tag_count = 0;

// Trim whitespace from each of the exclude keywords
$exclude = array_map('trim', $exclude);	

foreach ($docTags as $n => $v) {
	if (is_array($v)){	// We should have an array containing only one key (tags)
		$this_tags = explode($tagDelim,$v['tags']);	// Split it by the tag delimiter		
		foreach ($this_tags as $tag) {		// Each of the new found tags
			$tag = trim($tag);	// Remove any whitespace
			$tag = ($caseSensitive) ? $tag : strtolower($tag);	// If not case sensitive, lower-case it
			if ($tag != '' && !in_array($tag, $exclude)) {	// if its not empty after all this
				$tag_count++;
				if (isset($tags[$tag]['count'])) {	// if we've already met this tag, increment its counter
					$tags[$tag]['count']++;	
				} else {	// Otherwise create a counter for it
					$tags[$tag]['count'] = 1;
				}
			}
		}
	}
}



// Add in any extraTags
foreach ($extraTags as $x) {
	$tags[$x]['count'] = 0;	
}


// Now we've totalled up how often each word appears, determine what style we should apply
foreach ($tags as $tag => $data) {
	
	// if this tag has less than the minimum required count, remove it
	if ($min > 0 && $data['count'] < $min) {
		unset($tags[$tag]);
		break;
	}	
	
	$chosen_style = 0;	// a default style
    $step = $data['count'] == 0 ? 1 : 100 / $data['count']; // get percentage
	
	for ($i=0;$i<count($steps);$i++) {
		if ($step <= $steps[$i]) {
			$tags[$tag]['style'] = $styles[$i];
			break;
		}
	}	

// Left in for debugging	
/*	echo "-------------- $tag \n";
	echo "total tag_count: $tag_count \n";
	echo "this tag count: ".$data['count']." \n";
	echo "step: $step \n";
	echo "chosen_style: ".$tags[$tag]['style']." \n";*/
			
}


// How do we want the words sorted?
switch ($sort) {
	case 'asc': 
		ksort($tags); //sort them alphabetically 
	break;
	
	case 'desc':
		krsort($tags); //sort them reverse alphabetically
	break;
	case 'numasc':
		asort($tags); // sort by value asc
	break;
	
	case 'numdesc':
		arsort($tags); // sort by value desc
	break;
	case 'random':	// Sort them randomly
		$keys = array_keys($tags);
		shuffle($keys);	
		$random_words  = array();	
		foreach ($keys as $key) {		
		  $random_words[$key] = $tags[$key];
		}
		$tags = $random_words;
	break;
	
	default: 
	break;
}


// If there are words which should be promoted (brought to beginning)
	$promote = array_reverse($promote); // The way we merge arrays means these have to be done in reverse order
foreach ($promote as $p) {
	$p = trim($p);
	$promoted_tag = $tags[$p];
	unset($tags[$p]);
	$tags = array_merge(array( $p => $promoted_tag), $tags);
}


// If there are words which should be demoted (brought to the end)
foreach ($demote as $d) {
	$d = trim($d);
	$demoted_tag = $tags[$d];
	unset($tags[$d]);
	$tags = array_merge($tags, array( $d => $demoted_tag));
}





/* ------------- Output ------------- */



switch ($displayType) {
		case 'cloud': 
			$start = '<div class="tagcloud">';
			$tpl = '<span><a class="[+class+]" href="[~[+landing+]~][+qs_seperator+][+url_param+]=[+urlencoded_tag+]" title="Click for items tagged [+tag+] [+bracketed_count+]">[+tag+] [+bracketed_count+]</a></span>'."\r\n";
			$end =  '</div>';
		break;
		
		case 'list':
			$start = '<ul>';
			$tpl = '<li><a href="[~[+landing+]~][+qs_seperator+][+url_param+]=[+urlencoded_tag+]" title="Click for items tagged [+tag+] [+bracketed_count+]">[+tag+] [+bracketed_count+]</a></li>'."\r\n";
			$end =  '</ul>';
		break;
		
		case 'custom':
			$start = '';
			$tpl = $modx->getChunk($customDisplayChunk);
			$end = '';
		break;
}


	

// How many tags should we display?
$tags_still_to_show = ($limit == 0) ? count($tags) : $limit;

// Assemble the output
$output = $start;


// Go through each of the tags
foreach ($tags as $tag => $value) {
	
	if ($tags_still_to_show == 0) {
		break;
	}

	$count_value = $value['count'];
	$this_style = $value['style'];
	$tag = trim($tag);
	
	// Are we viewing the current search results? If so, hilight the current tag
	$current_filters = explode($tagDelim, $_GET[$urlParam]);
	$current_filters = array_map('trim', $current_filters);
	if ( in_array($tag, $current_filters) ) {
		$this_style .= ' ' .$currentClass;
	}
	
	$count = ($showCount) ? $count_value : '';
	$bracketed_count = ($showCount) ? '(' . $count_value . ')' : '';
		
	// Choose the correct string seperator depending on whether we are using friendly URLs, and XHTML URLs
	$url_amp = $modx->config['xhtml_urls']?'&amp;':'&';
	$query_string_seperator = ($modx->config['friendly_urls'])?'?':$url_amp;
	
	// Replace the values
	$placeholders = array('[+class+]', '[+landing+]', '[+qs_seperator+]', '[+url_param+]', '[+tag+]', '[+urlencoded_tag+]', '[+tooltip+]', '[+count+]', '[+bracketed_count+]');
	$new_values = array($this_style, $landing, $query_string_seperator, $dittoID.$urlParam, $tag, urlencode($tag), $this_tooltip, $count, $bracketed_count );
	
	$output .= str_replace($placeholders, $new_values, $tpl);
	
	
	$tags_still_to_show--;	
}


// Finish the output
$output .= $end;


return $output;
