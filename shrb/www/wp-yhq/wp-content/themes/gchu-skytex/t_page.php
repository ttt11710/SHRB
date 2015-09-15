<?php get_header();?>
<?php
/**
 * The page template.
 * @package highwind
 * @since 1.0
 *
 * Template name: aaaaaa
 */
?>

<?php
?>

<body>

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

<!-- <?php wp_footer(); ?> -->

</body>