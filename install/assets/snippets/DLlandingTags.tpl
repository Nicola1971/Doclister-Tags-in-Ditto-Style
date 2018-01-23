<?php
/**
 * DLlandingTags
 *
 * Create a Doclister Tags Landing Page in Ditto style
 *
 * @category  Content
 * @version   0.2
 * @license   GNU General Public License (GPL), http://www.gnu.org/copyleft/gpl.html
 * @author pmfx, Nicola1971
 *
 * @example
 *      [[DLlandingTags? &parents=`0` &paginate=`1` &tpl=`blogTPL` &tagTV=`documentTags` &display=`10` &depth=`4` &tvList=`image,documentTags`]]
 */
$id = isset( $id ) ? $id : "tags";
$tagTV = isset( $tagTV ) ? $tagTV : "documentTags";
$parents = isset( $parents ) ? $parents : "";
$display = isset( $display ) ? $display : "";
$depth = isset( $depth ) ? $depth : "";
$tvList = isset( $tvList ) ? $tvList : "";
$tpl = isset( $tpl ) ? $tpl : "";
$addWhereList = isset( $addWhereList ) ? $addWhereList : "";
//ditto [+author+] replacement:  [+user.username.createdby+]
$extender = isset( $extender ) ? $extender : "user";
$usertype = isset( $usertype ) ? $usertype : "mgr";
$userFields = isset( $userFields ) ? $userFields : "createdby,publishedby";
$debug = isset( $debug ) ? $debug : "0";
//paginate 
$paginate = isset( $paginate ) ? $paginate : "pages"; //"offset" for pagination ditto style

$TplWrapPaginate = isset( $TplWrapPaginate ) ? $TplWrapPaginate : "@CODE:<ul class=\"pagination\">[+wrap+]</ul>";
$TplPage = isset( $TplPage ) ? $TplPage : "@CODE:<li><a href=\"[+link+]\" class=\"page\">[+num+]</a></li>";
$TplNextP = isset( $TplNextP ) ? $TplNextP : "@CODE:<li><a href=\"[+link+]\">[%paginate.next%] ></a></li>";
$TplPrevP = isset( $TplPrevP ) ? $TplPrevP : "@CODE:<li><a href=\"[+link+]\"> < [%paginate.prev%]</a></li>";
$TplDotsPage = isset( $TplDotsPage ) ? $TplDotsPage : "@CODE:<li><a href=\"[+link+]\" onclick=\"return false;\"> ...</a></li>";
$TplCurrentPage = isset( $TplCurrentPage ) ? $TplCurrentPage : "@CODE:<li class=\"active\"><a href=\"[+link+]\" onclick=\"return false;\">[+num+]</a></li>";

// DocLister tags from TV
// This example contains only required code for tags - add your own needed params
$params['parents']     = $parents;
$params['debug']     = $debug;
$params['display']     = $display;
$params['depth']     = $depth;
$params['id']     = $id;
$params['tvList'] = $tvList;
$params['tpl']    = $tpl;
$params['addWhereList']    = $addWhereList;
$params['tvPrefix']    = '';
$params['noneTPL']    = $noneTPL;
$params['paginate']    = $paginate;
//ditto author replacement
$params['extender']    = $extender;
$params['usertype']    = $usertype;
$params['userFields']    = $userFields;
//pagination tpls
/**
$params['TplWrapPaginate']    = $TplWrapPaginate;
$params['TplPage']    = $TplPage;
$params['TplNextP']    = $TplNextP;
$params['TplPrevP']    = $TplPrevP;
$params['TplDotsPage']     = $TplDotsPage;
$params['TplCurrentPage']     = $TplCurrentPage;
**/
// tags
$tags_get_var_name  = $params['id'];
//encode tags url "tag+name" instead "tag%20name"
$urlencoded_tag = preg_replace('/\s+/', '+', $tags_get_var_name);
$tags_get_var_value = $_GET[$urlencoded_tag];
// filter results if tags are provided
if($tags_get_var_value != ''){
  $params['filter_delimiter']=', ';
  $params['filters']='AND(tv:'.$tagTV.':containsOne:'.$tags_get_var_value.')';
}
// generate tags placeholder for the landing page title
$modx->setPlaceholder("tags", $tags_get_var_value);

// generate list
$output = $modx->runSnippet('DocLister',$params);
$output .= '<div id="dl_pages">[+'.$id.'.pages+]</div>';
return $output;
