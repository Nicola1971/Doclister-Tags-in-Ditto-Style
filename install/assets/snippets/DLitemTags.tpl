<?php
/**
 * DLitemTags
 *
 * Snippet to display linked tv tags
 *
 * @category  Tagging
 * @version   0.2.3
 * @license   GNU General Public License (GPL), http://www.gnu.org/copyleft/gpl.html
 * @author pmfx, Nicola1971
 *
 * @example
 *      [[DL_itemTags? &id=`tags` &tags=`[+documentTags+]` &tagparam=`tags` &tagsLanding=`176`]]
 */
<?php
// Snippet to display linked tv tags in item tpl 
// [[DL_itemTags? &id=`tags` &tags=`[+documentTags+]` &tagsparam=`tags` &tagsLanding=`176`]]
$tags = isset( $tags ) ? $tags : "[+documentTags+]";
$tagsparam = isset( $tagsparam ) ? $tagsparam : "tags";
$tagsLanding = isset( $tagsLanding ) ? $tagsLanding : "";
$output = '';
if ($tags != '') {
  $tagsArray = explode(',', $tags);
  $i = 0;
  $len = count($tagsArray);
  foreach ( $tagsArray as $key => $val ) {
	$trimval = trim($val);
	$urlencoded_tag = preg_replace('/\s+/', '+', $trimval);
    $tpl = '<a href="[~'.$tagsLanding.'~]?'.$tagsparam.'='.$urlencoded_tag.'">'.$val.'</a>';
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