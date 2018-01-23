<?php
/**
 * DLitemTags
 *
 * Snippet to display linked tv tags in item tpl
 *
 * @category  Content
 * @version   0.2
 * @license   GNU General Public License (GPL), http://www.gnu.org/copyleft/gpl.html
 * @author pmfx
 *
 * @example
 *      [[DLlandingTags? &parents=`0` &paginate=`1` &tpl=`blogTPL`  &display=`10` &depth=`4` &tvList=`image,documentTags`]]
 */
$output = '';
if ($tags != '') {
  $tagsArray = explode(',', $tags);
  $i = 0;
  $len = count($tagsArray);
  while(list($key,$val)=each($tagsArray)){
	$trimval = trim($val);
	$urlencoded_tag = preg_replace('/\s+/', '+', $trimval);
    $tpl = '<a href="[~'.$tagsLanding.'~]?tags='.$urlencoded_tag.'">'.$val.'</a>';
    
    // remove comma from last item
    if ($i == $len - 1) {
      $output .= $tpl;
    }
    
    // every other item
    else {
      $output .= $tpl.', ';
    }
    
    $i++;
  }
}
return $output;