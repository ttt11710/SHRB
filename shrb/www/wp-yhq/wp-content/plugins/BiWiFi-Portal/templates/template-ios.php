<?php
/**
 * The page template.
 * @package highwind
 * @since 1.0
 *
 * Template name: Blank
 */
?>

<?php
if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly
?>

<!doctype html><!--[if lt IE 7 ]> <html <?php language_attributes(); ?> class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html <?php language_attributes(); ?> class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html <?php language_attributes(); ?> class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html <?php language_attributes(); ?> class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html <?php language_attributes(); ?> class="no-js"> <!--<![endif]-->
<head>

	<meta charset="<?php bloginfo( 'charset' ); ?>" />

	<!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

	<title>Success</title>

	<!--  Mobile viewport optimized: j.mp/bplateviewport -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<?php wp_head(); ?>

</head>

<body <?php body_class(); ?>>
<?php $title=get_the_title(); ?>
<script>
	var title='<?php echo $title; ?>';
	// console.log(title);
	document.title=title;
</script>
<div class="outer-wrap" id="top">

	<div class="inner-wrap">

	<div class="content-wrapper">

		<section class="content" role="main">


			<?php while ( have_posts() ) : the_post(); ?>

				<article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>

					<section class="article-content">

						<?php

							the_content();

						?>

					</section><!-- /.article-content -->

				</article><!-- #post-<?php the_ID(); ?> -->

			<?php endwhile; // end of the loop. ?>

		</section><!-- /.content -->

	</div><!-- /.content-wrapper -->

	</div><!-- /.inner-wrap -->

</div><!-- /.outer-wrap -->

<?php wp_footer(); ?>

</body>
</html>