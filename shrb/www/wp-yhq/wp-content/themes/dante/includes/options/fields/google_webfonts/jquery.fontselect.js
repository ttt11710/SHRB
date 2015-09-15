jQuery(document).ready(function ($) {
    var googlefont = jQuery('.font').fontselect();
	
	jQuery(".font").change(function() {
		console.log(googlefont);
		googlefont = jQuery(this);
		console.log(googlefont);
		fontset(googlefont);
	});

    function fontset(googlefont) {
        var relid = googlefont.attr('id');

        // replace + signs with spaces for css
        var font = googlefont.val().replace(/\+/g, ' ');

        // split font into family and weight
        font = font.split(':');
		
		var style = "normal";
		var weight = font[1];
		
		if (font[1].indexOf("italic") >= 0) {
			style = "italic";
		}
		
        // set family on example
        jQuery('#' + relid + '.example').css('font-family', font[0]);
        jQuery('#' + relid + '.example').css('font-weight', weight.replace('italic',''));
    	jQuery('#' + relid + '.example').css('font-style', style);
    }
});

/*!
 * jQuery.fontselect - A font selector for the Google Web Fonts api
 * Tom Moor, http://tommoor.com
 * Copyright (c) 2011 Tom Moor
 * MIT Licensed
 * @version 0.1
*/

(function($){

  $.fn.fontselect = function(options) {

    var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

    var _fonts = [
		'ABeeZee:400',
		'ABeeZee:italic',
		'Abel:400',
		'Abril Fatface:400',
		'Aclonica:400',
		'Acme:400',
		'Actor:400',
		'Adamina:400',
		'Advent Pro:100',
		'Advent Pro:200',
		'Advent Pro:300',
		'Advent Pro:400',
		'Advent Pro:500',
		'Advent Pro:600',
		'Advent Pro:700',
		'Aguafina Script:400',
		'Akronim:400',
		'Aladin:400',
		'Aldrich:400',
		'Alef:400',
		'Alef:700',
		'Alegreya:400',
		'Alegreya:italic',
		'Alegreya:700',
		'Alegreya:700italic',
		'Alegreya:900',
		'Alegreya:900italic',
		'Alegreya SC:400',
		'Alegreya SC:italic',
		'Alegreya SC:700',
		'Alegreya SC:700italic',
		'Alegreya SC:900',
		'Alegreya SC:900italic',
		'Alex Brush:400',
		'Alfa Slab One:400',
		'Alice:400',
		'Alike:400',
		'Alike Angular:400',
		'Allan:400',
		'Allan:700',
		'Allerta:400',
		'Allerta Stencil:400',
		'Allura:400',
		'Almendra:400',
		'Almendra:italic',
		'Almendra:700',
		'Almendra:700italic',
		'Almendra Display:400',
		'Almendra SC:400',
		'Amarante:400',
		'Amaranth:400',
		'Amaranth:italic',
		'Amaranth:700',
		'Amaranth:700italic',
		'Amatic SC:400',
		'Amatic SC:700',
		'Amethysta:400',
		'Anaheim:400',
		'Andada:400',
		'Andika:400',
		'Angkor:400',
		'Annie Use Your Telescope:400',
		'Anonymous Pro:400',
		'Anonymous Pro:italic',
		'Anonymous Pro:700',
		'Anonymous Pro:700italic',
		'Antic:400',
		'Antic Didone:400',
		'Antic Slab:400',
		'Anton:400',
		'Arapey:400',
		'Arapey:italic',
		'Arbutus:400',
		'Arbutus Slab:400',
		'Architects Daughter:400',
		'Archivo Black:400',
		'Archivo Narrow:400',
		'Archivo Narrow:italic',
		'Archivo Narrow:700',
		'Archivo Narrow:700italic',
		'Arimo:400',
		'Arimo:italic',
		'Arimo:700',
		'Arimo:700italic',
		'Arizonia:400',
		'Armata:400',
		'Artifika:400',
		'Arvo:400',
		'Arvo:italic',
		'Arvo:700',
		'Arvo:700italic',
		'Asap:400',
		'Asap:italic',
		'Asap:700',
		'Asap:700italic',
		'Asset:400',
		'Astloch:400',
		'Astloch:700',
		'Asul:400',
		'Asul:700',
		'Atomic Age:400',
		'Aubrey:400',
		'Audiowide:400',
		'Autour One:400',
		'Average:400',
		'Average Sans:400',
		'Averia Gruesa Libre:400',
		'Averia Libre:300',
		'Averia Libre:300',
		'Averia Libre:400',
		'Averia Libre:italic',
		'Averia Libre:700',
		'Averia Libre:700italic',
		'Averia Sans Libre:300',
		'Averia Sans Libre:300',
		'Averia Sans Libre:400',
		'Averia Sans Libre:italic',
		'Averia Sans Libre:700',
		'Averia Sans Libre:700italic',
		'Averia Serif Libre:300',
		'Averia Serif Libre:300',
		'Averia Serif Libre:400',
		'Averia Serif Libre:italic',
		'Averia Serif Libre:700',
		'Averia Serif Libre:700italic',
		'Bad Script:400',
		'Balthazar:400',
		'Bangers:400',
		'Basic:400',
		'Battambang:400',
		'Battambang:700',
		'Baumans:400',
		'Bayon:400',
		'Belgrano:400',
		'Belleza:400',
		'BenchNine:300',
		'BenchNine:400',
		'BenchNine:700',
		'Bentham:400',
		'Berkshire Swash:400',
		'Bevan:400',
		'Bigelow Rules:400',
		'Bigshot One:400',
		'Bilbo:400',
		'Bilbo Swash Caps:400',
		'Bitter:400',
		'Bitter:italic',
		'Bitter:700',
		'Black Ops One:400',
		'Bokor:400',
		'Bonbon:400',
		'Boogaloo:400',
		'Bowlby One:400',
		'Bowlby One SC:400',
		'Brawler:400',
		'Bree Serif:400',
		'Bubblegum Sans:400',
		'Bubbler One:400',
		'Buda:300',
		'Buenard:400',
		'Buenard:700',
		'Butcherman:400',
		'Butterfly Kids:400',
		'Cabin:400',
		'Cabin:italic',
		'Cabin:500',
		'Cabin:500italic',
		'Cabin:600',
		'Cabin:600italic',
		'Cabin:700',
		'Cabin:700italic',
		'Cabin Condensed:400',
		'Cabin Condensed:500',
		'Cabin Condensed:600',
		'Cabin Condensed:700',
		'Cabin Sketch:400',
		'Cabin Sketch:700',
		'Caesar Dressing:400',
		'Cagliostro:400',
		'Calligraffitti:400',
		'Cambo:400',
		'Candal:400',
		'Cantarell:400',
		'Cantarell:italic',
		'Cantarell:700',
		'Cantarell:700italic',
		'Cantata One:400',
		'Cantora One:400',
		'Capriola:400',
		'Cardo:400',
		'Cardo:italic',
		'Cardo:700',
		'Carme:400',
		'Carrois Gothic:400',
		'Carrois Gothic SC:400',
		'Carter One:400',
		'Caudex:400',
		'Caudex:italic',
		'Caudex:700',
		'Caudex:700italic',
		'Cedarville Cursive:400',
		'Ceviche One:400',
		'Changa One:400',
		'Changa One:italic',
		'Chango:400',
		'Chau Philomene One:400',
		'Chau Philomene One:italic',
		'Chela One:400',
		'Chelsea Market:400',
		'Chenla:400',
		'Cherry Cream Soda:400',
		'Cherry Swash:400',
		'Cherry Swash:700',
		'Chewy:400',
		'Chicle:400',
		'Chivo:400',
		'Chivo:italic',
		'Chivo:900',
		'Chivo:900italic',
		'Cinzel:400',
		'Cinzel:700',
		'Cinzel:900',
		'Cinzel Decorative:400',
		'Cinzel Decorative:700',
		'Cinzel Decorative:900',
		'Clicker Script:400',
		'Coda:400',
		'Coda:800',
		'Coda Caption:800',
		'Codystar:300',
		'Codystar:400',
		'Combo:400',
		'Comfortaa:300',
		'Comfortaa:400',
		'Comfortaa:700',
		'Coming Soon:400',
		'Concert One:400',
		'Condiment:400',
		'Content:400',
		'Content:700',
		'Contrail One:400',
		'Convergence:400',
		'Cookie:400',
		'Copse:400',
		'Corben:400',
		'Corben:700',
		'Courgette:400',
		'Cousine:400',
		'Cousine:italic',
		'Cousine:700',
		'Cousine:700italic',
		'Coustard:400',
		'Coustard:900',
		'Covered By Your Grace:400',
		'Crafty Girls:400',
		'Creepster:400',
		'Crete Round:400',
		'Crete Round:italic',
		'Crimson Text:400',
		'Crimson Text:italic',
		'Crimson Text:600',
		'Crimson Text:600italic',
		'Crimson Text:700',
		'Crimson Text:700italic',
		'Croissant One:400',
		'Crushed:400',
		'Cuprum:400',
		'Cuprum:italic',
		'Cuprum:700',
		'Cuprum:700italic',
		'Cutive:400',
		'Cutive Mono:400',
		'Damion:400',
		'Dancing Script:400',
		'Dancing Script:700',
		'Dangrek:400',
		'Dawning of a New Day:400',
		'Days One:400',
		'Delius:400',
		'Delius Swash Caps:400',
		'Delius Unicase:400',
		'Delius Unicase:700',
		'Della Respira:400',
		'Denk One:400',
		'Devonshire:400',
		'Didact Gothic:400',
		'Diplomata:400',
		'Diplomata SC:400',
		'Domine:400',
		'Domine:700',
		'Donegal One:400',
		'Doppio One:400',
		'Dorsa:400',
		'Dosis:200',
		'Dosis:300',
		'Dosis:400',
		'Dosis:500',
		'Dosis:600',
		'Dosis:700',
		'Dosis:800',
		'Dr Sugiyama:400',
		'Droid Sans:400',
		'Droid Sans:700',
		'Droid Sans Mono:400',
		'Droid Serif:400',
		'Droid Serif:italic',
		'Droid Serif:700',
		'Droid Serif:700italic',
		'Duru Sans:400',
		'Dynalight:400',
		'EB Garamond:400',
		'Eagle Lake:400',
		'Eater:400',
		'Economica:400',
		'Economica:italic',
		'Economica:700',
		'Economica:700italic',
		'Electrolize:400',
		'Elsie:400',
		'Elsie:900',
		'Elsie Swash Caps:400',
		'Elsie Swash Caps:900',
		'Emblema One:400',
		'Emilys Candy:400',
		'Engagement:400',
		'Englebert:400',
		'Enriqueta:400',
		'Enriqueta:700',
		'Erica One:400',
		'Esteban:400',
		'Euphoria Script:400',
		'Ewert:400',
		'Exo:100',
		'Exo:100italic',
		'Exo:200',
		'Exo:200italic',
		'Exo:300',
		'Exo:300',
		'Exo:400',
		'Exo:italic',
		'Exo:500',
		'Exo:500italic',
		'Exo:600',
		'Exo:600italic',
		'Exo:700',
		'Exo:700italic',
		'Exo:800',
		'Exo:800italic',
		'Exo:900',
		'Exo:900italic',
		'Expletus Sans:400',
		'Expletus Sans:italic',
		'Expletus Sans:500',
		'Expletus Sans:500italic',
		'Expletus Sans:600',
		'Expletus Sans:600italic',
		'Expletus Sans:700',
		'Expletus Sans:700italic',
		'Fanwood Text:400',
		'Fanwood Text:italic',
		'Fascinate:400',
		'Fascinate Inline:400',
		'Faster One:400',
		'Fasthand:400',
		'Fauna One:400',
		'Federant:400',
		'Federo:400',
		'Felipa:400',
		'Fenix:400',
		'Finger Paint:400',
		'Fjalla One:400',
		'Fjord One:400',
		'Flamenco:300',
		'Flamenco:400',
		'Flavors:400',
		'Fondamento:400',
		'Fondamento:italic',
		'Fontdiner Swanky:400',
		'Forum:400',
		'Francois One:400',
		'Freckle Face:400',
		'Fredericka the Great:400',
		'Fredoka One:400',
		'Freehand:400',
		'Fresca:400',
		'Frijole:400',
		'Fruktur:400',
		'Fugaz One:400',
		'GFS Didot:400',
		'GFS Neohellenic:400',
		'GFS Neohellenic:italic',
		'GFS Neohellenic:700',
		'GFS Neohellenic:700italic',
		'Gabriela:400',
		'Gafata:400',
		'Galdeano:400',
		'Galindo:400',
		'Gentium Basic:400',
		'Gentium Basic:italic',
		'Gentium Basic:700',
		'Gentium Basic:700italic',
		'Gentium Book Basic:400',
		'Gentium Book Basic:italic',
		'Gentium Book Basic:700',
		'Gentium Book Basic:700italic',
		'Geo:400',
		'Geo:italic',
		'Geostar:400',
		'Geostar Fill:400',
		'Germania One:400',
		'Gilda Display:400',
		'Give You Glory:400',
		'Glass Antiqua:400',
		'Glegoo:400',
		'Gloria Hallelujah:400',
		'Goblin One:400',
		'Gochi Hand:400',
		'Gorditas:400',
		'Gorditas:700',
		'Goudy Bookletter 1911:400',
		'Graduate:400',
		'Grand Hotel:400',
		'Gravitas One:400',
		'Great Vibes:400',
		'Griffy:400',
		'Gruppo:400',
		'Gudea:400',
		'Gudea:italic',
		'Gudea:700',
		'Habibi:400',
		'Hammersmith One:400',
		'Hanalei:400',
		'Hanalei Fill:400',
		'Handlee:400',
		'Hanuman:400',
		'Hanuman:700',
		'Happy Monkey:400',
		'Headland One:400',
		'Henny Penny:400',
		'Herr Von Muellerhoff:400',
		'Holtwood One SC:400',
		'Homemade Apple:400',
		'Homenaje:400',
		'IM Fell DW Pica:400',
		'IM Fell DW Pica:italic',
		'IM Fell DW Pica SC:400',
		'IM Fell Double Pica:400',
		'IM Fell Double Pica:italic',
		'IM Fell Double Pica SC:400',
		'IM Fell English:400',
		'IM Fell English:italic',
		'IM Fell English SC:400',
		'IM Fell French Canon:400',
		'IM Fell French Canon:italic',
		'IM Fell French Canon SC:400',
		'IM Fell Great Primer:400',
		'IM Fell Great Primer:italic',
		'IM Fell Great Primer SC:400',
		'Iceberg:400',
		'Iceland:400',
		'Imprima:400',
		'Inconsolata:400',
		'Inconsolata:700',
		'Inder:400',
		'Indie Flower:400',
		'Inika:400',
		'Inika:700',
		'Irish Grover:400',
		'Istok Web:400',
		'Istok Web:italic',
		'Istok Web:700',
		'Istok Web:700italic',
		'Italiana:400',
		'Italianno:400',
		'Jacques Francois:400',
		'Jacques Francois Shadow:400',
		'Jim Nightshade:400',
		'Jockey One:400',
		'Jolly Lodger:400',
		'Josefin Sans:100',
		'Josefin Sans:100italic',
		'Josefin Sans:300',
		'Josefin Sans:300',
		'Josefin Sans:400',
		'Josefin Sans:italic',
		'Josefin Sans:600',
		'Josefin Sans:600italic',
		'Josefin Sans:700',
		'Josefin Sans:700italic',
		'Josefin Slab:100',
		'Josefin Slab:100italic',
		'Josefin Slab:300',
		'Josefin Slab:300',
		'Josefin Slab:400',
		'Josefin Slab:italic',
		'Josefin Slab:600',
		'Josefin Slab:600italic',
		'Josefin Slab:700',
		'Josefin Slab:700italic',
		'Joti One:400',
		'Judson:400',
		'Judson:italic',
		'Judson:700',
		'Julee:400',
		'Julius Sans One:400',
		'Junge:400',
		'Jura:300',
		'Jura:400',
		'Jura:500',
		'Jura:600',
		'Just Another Hand:400',
		'Just Me Again Down Here:400',
		'Kameron:400',
		'Kameron:700',
		'Karla:400',
		'Karla:italic',
		'Karla:700',
		'Karla:700italic',
		'Kaushan Script:400',
		'Kavoon:400',
		'Keania One:400',
		'Kelly Slab:400',
		'Kenia:400',
		'Khmer:400',
		'Kite One:400',
		'Knewave:400',
		'Kotta One:400',
		'Koulen:400',
		'Kranky:400',
		'Kreon:300',
		'Kreon:400',
		'Kreon:700',
		'Kristi:400',
		'Krona One:400',
		'La Belle Aurore:400',
		'Lancelot:400',
		'Lato:100',
		'Lato:100italic',
		'Lato:300',
		'Lato:300',
		'Lato:400',
		'Lato:italic',
		'Lato:700',
		'Lato:700italic',
		'Lato:900',
		'Lato:900italic',
		'League Script:400',
		'Leckerli One:400',
		'Ledger:400',
		'Lekton:400',
		'Lekton:italic',
		'Lekton:700',
		'Lemon:400',
		'Libre Baskerville:400',
		'Libre Baskerville:italic',
		'Libre Baskerville:700',
		'Life Savers:400',
		'Life Savers:700',
		'Lilita One:400',
		'Lily Script One:400',
		'Limelight:400',
		'Linden Hill:400',
		'Linden Hill:italic',
		'Lobster:400',
		'Lobster Two:400',
		'Lobster Two:italic',
		'Lobster Two:700',
		'Lobster Two:700italic',
		'Londrina Outline:400',
		'Londrina Shadow:400',
		'Londrina Sketch:400',
		'Londrina Solid:400',
		'Lora:400',
		'Lora:italic',
		'Lora:700',
		'Lora:700italic',
		'Love Ya Like A Sister:400',
		'Loved by the King:400',
		'Lovers Quarrel:400',
		'Luckiest Guy:400',
		'Lusitana:400',
		'Lusitana:700',
		'Lustria:400',
		'Macondo:400',
		'Macondo Swash Caps:400',
		'Magra:400',
		'Magra:700',
		'Maiden Orange:400',
		'Mako:400',
		'Marcellus:400',
		'Marcellus SC:400',
		'Marck Script:400',
		'Margarine:400',
		'Marko One:400',
		'Marmelad:400',
		'Marvel:400',
		'Marvel:italic',
		'Marvel:700',
		'Marvel:700italic',
		'Mate:400',
		'Mate:italic',
		'Mate SC:400',
		'Maven Pro:400',
		'Maven Pro:500',
		'Maven Pro:700',
		'Maven Pro:900',
		'McLaren:400',
		'Meddon:400',
		'MedievalSharp:400',
		'Medula One:400',
		'Megrim:400',
		'Meie Script:400',
		'Merienda:400',
		'Merienda:700',
		'Merienda One:400',
		'Merriweather:300',
		'Merriweather:300',
		'Merriweather:400',
		'Merriweather:italic',
		'Merriweather:700',
		'Merriweather:700italic',
		'Merriweather:900',
		'Merriweather:900italic',
		'Merriweather Sans:300',
		'Merriweather Sans:300',
		'Merriweather Sans:400',
		'Merriweather Sans:italic',
		'Merriweather Sans:700',
		'Merriweather Sans:700italic',
		'Merriweather Sans:800',
		'Merriweather Sans:800italic',
		'Metal:400',
		'Metal Mania:400',
		'Metamorphous:400',
		'Metrophobic:400',
		'Michroma:400',
		'Milonga:400',
		'Miltonian:400',
		'Miltonian Tattoo:400',
		'Miniver:400',
		'Miss Fajardose:400',
		'Modern Antiqua:400',
		'Molengo:400',  
		'Molle:italic',
		'Monda:400',
		'Monda:700',
		'Monofett:400',
		'Monoton:400',
		'Monsieur La Doulaise:400',
		'Montaga:400',
		'Montez:400',
		'Montserrat:400',
		'Montserrat:700',
		'Montserrat Alternates:400',
		'Montserrat Alternates:700',
		'Montserrat Subrayada:400',
		'Montserrat Subrayada:700',
		'Moul:400',
		'Moulpali:400',
		'Mountains of Christmas:400',
		'Mountains of Christmas:700',
		'Mouse Memoirs:400',
		'Mr Bedfort:400',
		'Mr Dafoe:400',
		'Mr De Haviland:400',  
		'Mrs Saint Delafield:400',
		'Mrs Sheppards:400',
		'Muli:300',
		'Muli:300',
		'Muli:400',
		'Muli:italic',
		'Mystery Quest:400',
		'Neucha:400',
		'Neuton:200',
		'Neuton:300',
		'Neuton:400',
		'Neuton:italic',
		'Neuton:700',
		'Neuton:800',
		'New Rocker:400',
		'News Cycle:400',
		'News Cycle:700',
		'Niconne:400',
		'Nixie One:400',
		'Nobile:400',
		'Nobile:italic',
		'Nobile:700',
		'Nobile:700italic',
		'Nokora:400',
		'Nokora:700',
		'Norican:400',
		'Nosifer:400',
		'Nothing You Could Do:400',
		'Noticia Text:400',
		'Noticia Text:italic',
		'Noticia Text:700',
		'Noticia Text:700italic',
		'Noto Sans:400',
		'Noto Sans:italic',
		'Noto Sans:700',
		'Noto Sans:700italic',
		'Noto Serif:400',
		'Noto Serif:italic',
		'Noto Serif:700',
		'Noto Serif:700italic',
		'Nova Cut:400',
		'Nova Flat:400',
		'Nova Mono:400',
		'Nova Oval:400',
		'Nova Round:400',
		'Nova Script:400',
		'Nova Slim:400',
		'Nova Square:400',
		'Numans:400',
		'Nunito:300',
		'Nunito:400',
		'Nunito:700',
		'Odor Mean Chey:400',
		'Offside:400',
		'Old Standard TT:400',
		'Old Standard TT:italic',
		'Old Standard TT:700',
		'Oldenburg:400',
		'Oleo Script:400',
		'Oleo Script:700',
		'Oleo Script Swash Caps:400',
		'Oleo Script Swash Caps:700',
		'Open Sans:300',
		'Open Sans:400',
		'Open Sans:italic',
		'Open Sans:600',
		'Open Sans:600italic',
		'Open Sans:700',
		'Open Sans:700italic',
		'Open Sans:800',
		'Open Sans:800italic',
		'Open Sans Condensed:300',
		'Open Sans Condensed:300',
		'Open Sans Condensed:700',
		'Oranienbaum:400',
		'Orbitron:400',
		'Orbitron:500',
		'Orbitron:700',
		'Orbitron:900',
		'Oregano:400',
		'Oregano:italic',
		'Orienta:400',
		'Original Surfer:400',
		'Oswald:300',
		'Oswald:400',
		'Oswald:700',
		'Over the Rainbow:400',
		'Overlock:400',
		'Overlock:italic',
		'Overlock:700',
		'Overlock:700italic',
		'Overlock:900',
		'Overlock:900italic',
		'Overlock SC:400',
		'Ovo:400',
		'Oxygen:300',
		'Oxygen:400',
		'Oxygen:700',
		'Oxygen Mono:400',
		'PT Mono:400',
		'PT Sans:400',
		'PT Sans:italic',
		'PT Sans:700',
		'PT Sans:700italic',
		'PT Sans Caption:400',
		'PT Sans Caption:700',
		'PT Sans Narrow:400',
		'PT Sans Narrow:700',
		'PT Serif:400',
		'PT Serif:italic',
		'PT Serif:700',
		'PT Serif:700italic',
		'PT Serif Caption:400',
		'PT Serif Caption:italic',
		'Pacifico:400',
		'Paprika:400',
		'Parisienne:400',
		'Passero One:400',
		'Passion One:400',
		'Passion One:700',
		'Passion One:900',
		'Pathway Gothic One:400',  
		'Patrick Hand:400',
		'Patrick Hand SC:400',
		'Patua One:400',
		'Paytone One:400',
		'Peralta:400',
		'Permanent Marker:400',
		'Petit Formal Script:400',
		'Petrona:400',
		'Philosopher:400',
		'Philosopher:italic',
		'Philosopher:700',
		'Philosopher:700italic',
		'Piedra:400',
		'Pinyon Script:400',
		'Pirata One:400',
		'Plaster:400',
		'Play:400',
		'Play:700',
		'Playball:400',
		'Playfair Display:400',
		'Playfair Display:italic',
		'Playfair Display:700',
		'Playfair Display:700italic',
		'Playfair Display:900',
		'Playfair Display:900italic',
		'Playfair Display SC:400',
		'Playfair Display SC:italic',
		'Playfair Display SC:700',
		'Playfair Display SC:700italic',
		'Playfair Display SC:900',
		'Playfair Display SC:900italic',
		'Podkova:400',
		'Podkova:700',
		'Poiret One:400',
		'Poller One:400',
		'Poly:400',
		'Poly:italic',
		'Pompiere:400',
		'Pontano Sans:400',
		'Port Lligat Sans:400',
		'Port Lligat Slab:400',
		'Prata:400',
		'Preahvihear:400',
		'Press Start 2P:400',
		'Princess Sofia:400',
		'Prociono:400',
		'Prosto One:400',
		'Puritan:400',
		'Puritan:italic',
		'Puritan:700',
		'Puritan:700italic',
		'Purple Purse:400',
		'Quando:400',
		'Quantico:400',
		'Quantico:italic',
		'Quantico:700',
		'Quantico:700italic',
		'Quattrocento:400',
		'Quattrocento:700',
		'Quattrocento Sans:400',
		'Quattrocento Sans:italic',
		'Quattrocento Sans:700',
		'Quattrocento Sans:700italic',
		'Questrial:400',
		'Quicksand:300',
		'Quicksand:400',
		'Quicksand:700',
		'Quintessential:400',  
		'Qwigley:400',
		'Racing Sans One:400',
		'Radley:400',
		'Radley:italic',
		'Raleway:100',
		'Raleway:200',
		'Raleway:300',
		'Raleway:400',
		'Raleway:500',
		'Raleway:600',
		'Raleway:700',
		'Raleway:800',
		'Raleway:900',
		'Raleway Dots:400',
		'Rambla:400',
		'Rambla:italic',
		'Rambla:700',
		'Rambla:700italic',
		'Rammetto One:400',
		'Ranchers:400',
		'Rancho:400',
		'Rationale:400',
		'Redressed:400',
		'Reenie Beanie:400',
		'Revalia:400',  
		'Ribeye:400',
		'Ribeye Marrow:400',
		'Righteous:400',
		'Risque:400',
		'Roboto:100',
		'Roboto:100italic',
		'Roboto:300',
		'Roboto:300',
		'Roboto:400',
		'Roboto:italic',
		'Roboto:500',
		'Roboto:500italic',
		'Roboto:700',
		'Roboto:700italic',
		'Roboto:900',
		'Roboto:900italic',
		'Roboto Condensed:300',
		'Roboto Condensed:300',
		'Roboto Condensed:400',
		'Roboto Condensed:italic',
		'Roboto Condensed:700',
		'Roboto Condensed:700italic',
		'Roboto Slab:100',
		'Roboto Slab:300',
		'Roboto Slab:400',
		'Roboto Slab:700',
		'Rochester:400',
		'Rock Salt:400',
		'Rokkitt:400',
		'Rokkitt:700',
		'Romanesco:400',
		'Ropa Sans:400',
		'Ropa Sans:italic',
		'Rosario:400',
		'Rosario:italic',
		'Rosario:700',
		'Rosario:700italic',
		'Rosarivo:400',
		'Rosarivo:italic',
		'Rouge Script:400',
		'Ruda:400',
		'Ruda:700',
		'Ruda:900',
		'Rufina:400',
		'Rufina:700',
		'Ruge Boogie:400',
		'Ruluko:400',
		'Rum Raisin:400',
		'Ruslan Display:400',
		'Russo One:400',
		'Ruthie:400',
		'Rye:400',
		'Sacramento:400',
		'Sail:400',
		'Salsa:400',
		'Sanchez:400',
		'Sanchez:italic',
		'Sancreek:400',
		'Sansita One:400',
		'Sarina:400',
		'Satisfy:400',
		'Scada:400',
		'Scada:italic',
		'Scada:700',
		'Scada:700italic',
		'Schoolbell:400',
		'Seaweed Script:400',
		'Sevillana:400',
		'Seymour One:400',
		'Shadows Into Light:400',
		'Shadows Into Light Two:400',
		'Shanti:400',
		'Share:400',
		'Share:italic',
		'Share:700',
		'Share:700italic',
		'Share Tech:400',
		'Share Tech Mono:400',
		'Shojumaru:400',
		'Short Stack:400',
		'Siemreap:400',
		'Sigmar One:400',
		'Signika:300',
		'Signika:400',
		'Signika:600',
		'Signika:700',
		'Signika Negative:300',
		'Signika Negative:400',
		'Signika Negative:600',
		'Signika Negative:700',
		'Simonetta:400',
		'Simonetta:italic',
		'Simonetta:900',
		'Simonetta:900italic',
		'Sintony:400',
		'Sintony:700',
		'Sirin Stencil:400',
		'Six Caps:400',
		'Skranji:400',
		'Skranji:700',
		'Slackey:400',
		'Smokum:400',
		'Smythe:400',
		'Sniglet:400',
		'Sniglet:800',
		'Snippet:400',
		'Snowburst One:400',
		'Sofadi One:400',
		'Sofia:400',
		'Sonsie One:400',
		'Sorts Mill Goudy:400',
		'Sorts Mill Goudy:italic',
		'Source Code Pro:200',
		'Source Code Pro:300',
		'Source Code Pro:400',
		'Source Code Pro:500',
		'Source Code Pro:600',
		'Source Code Pro:700',
		'Source Code Pro:900',
		'Source Sans Pro:200',
		'Source Sans Pro:200italic',
		'Source Sans Pro:300',
		'Source Sans Pro:300',
		'Source Sans Pro:400',
		'Source Sans Pro:italic',
		'Source Sans Pro:600',
		'Source Sans Pro:600italic',
		'Source Sans Pro:700',
		'Source Sans Pro:700italic',
		'Source Sans Pro:900',
		'Source Sans Pro:900italic',
		'Special Elite:400',
		'Spicy Rice:400',
		'Spinnaker:400',
		'Spirax:400',
		'Squada One:400',
		'Stalemate:400',
		'Stalinist One:400',
		'Stardos Stencil:400',
		'Stardos Stencil:700',
		'Stint Ultra Condensed:400',
		'Stint Ultra Expanded:400',
		'Stoke:300',
		'Stoke:400',
		'Strait:400',
		'Sue Ellen Francisco:400',
		'Sunshiney:400',
		'Supermercado One:400',
		'Suwannaphum:400',
		'Swanky and Moo Moo:400',
		'Syncopate:400',
		'Syncopate:700',
		'Tangerine:400',
		'Tangerine:700',
		'Taprom:400',
		'Tauri:400',
		'Telex:400',
		'Tenor Sans:400',  
		'Text Me One:400',
		'The Girl Next Door:400',
		'Tienne:400',
		'Tienne:700',
		'Tienne:900',
		'Tinos:400',
		'Tinos:italic',
		'Tinos:700',
		'Tinos:700italic',
		'Titan One:400',
		'Titillium Web:200',
		'Titillium Web:200italic',
		'Titillium Web:300',
		'Titillium Web:300',
		'Titillium Web:400',
		'Titillium Web:italic',
		'Titillium Web:600',
		'Titillium Web:600italic',
		'Titillium Web:700',
		'Titillium Web:700italic',
		'Titillium Web:900',
		'Trade Winds:400',
		'Trocchi:400',  
		'Trochut:400',
		'Trochut:italic',
		'Trochut:700',
		'Trykker:400',
		'Tulpen One:400',
		'Ubuntu:300',
		'Ubuntu:300',
		'Ubuntu:400',
		'Ubuntu:italic',
		'Ubuntu:500',
		'Ubuntu:500italic',
		'Ubuntu:700',
		'Ubuntu:700italic',
		'Ubuntu Condensed:400',
		'Ubuntu Mono:400',
		'Ubuntu Mono:italic',
		'Ubuntu Mono:700',
		'Ubuntu Mono:700italic',
		'Ultra:400',
		'Uncial Antiqua:400',
		'Underdog:400',
		'Unica One:400',
		'UnifrakturCook:700',
		'UnifrakturMaguntia:400',
		'Unkempt:400',
		'Unkempt:700',
		'Unlock:400',
		'Unna:400',
		'VT323:400',
		'Vampiro One:400',
		'Varela:400',
		'Varela Round:400',
		'Vast Shadow:400',
		'Vibur:400',
		'Vidaloka:400',
		'Viga:400',
		'Voces:400',
		'Volkhov:400',
		'Volkhov:italic',
		'Volkhov:700',
		'Volkhov:700italic',
		'Vollkorn:400',
		'Vollkorn:italic',
		'Vollkorn:700',
		'Vollkorn:700italic',
		'Voltaire:400',
		'Waiting for the Sunrise:400',
		'Wallpoet:400',
		'Walter Turncoat:400',
		'Warnes:400',
		'Wellfleet:400',  
		'Wendy One:400',
		'Wire One:400',
		'Yanone Kaffeesatz:200',
		'Yanone Kaffeesatz:300',
		'Yanone Kaffeesatz:400',
		'Yanone Kaffeesatz:700',
		'Yellowtail:400',
		'Yeseva One:400',
		'Yesteryear:400',
		'Zeyada:400'
    ];

    var settings = $.extend( {
      style:            'font-select',
      placeholder:      'Select a font',
      lookahead:        2,
      cssUrl:          'http://fonts.googleapis.com/css?family=',
      fonts:            _fonts,
      apiUrl:           'https://www.googleapis.com/webfonts/v1/webfonts',
      apiKkey:          null,
      fetch:            false,
      combine:          false
    }, options);

    var Fontselect = (function(){

      function Fontselect(original, o){
        this.$original = $(original);
        this.options = o;
        this.active = false;
        this.setupHtml();
        this.setupFonts();
        if (this.options.fetch) {
          this.fetchFonts();
        }
      }

      Fontselect.prototype.fetchFonts = function () {
        var fontselect = this;
        var url = this.options.apiUrl;
        if (this.options.apiKey) {
          url = url + '?key=' + this.options.apiKey;
        }
        $.ajax({
          url: url,
          dataType: 'jsonp',
          success: function(data) {
            if (data.items && data.items.length > 0) {
              fontselect.options.fonts = [];
              $.each(data.items, function(key, font) {
                $.each(font.variants, function(key, variant) {
                  var family = font.family.replace(/ /g, '+');
                  if (font.variants.length > 1 || (variant != 400 && variant != 'regular')) {
                    family = family + ':' + variant;
                  }
                  fontselect.options.fonts.push(family);
                  //console.log('"'+family+'"');
                });
              });
            }
            fontselect.$drop.empty();
            fontselect.$results.empty();
            fontselect.$drop.append(fontselect.$results.append(fontselect.fontsAsHtml())).hide();
            $('li', fontselect.$results)
              .click(__bind(fontselect.selectFont, fontselect))
              .mouseenter(__bind(fontselect.activateFont, fontselect))
              .mouseleave(__bind(fontselect.deactivateFont, fontselect));
          },
          error: function(xmlhttp) {
            // JSONP doesn't trigger any event if there's an error with the request
          }
        });
      }

      Fontselect.prototype.setupFonts = function() {
        this.getVisibleFonts();
        this.bindEvents();

        var font = this.$original.val();
        if (font) {
          this.updateSelected();
          this.addFontLink(font);
        }
      }

      Fontselect.prototype.bindEvents = function(){

        $('li', this.$results)
        .click(__bind(this.selectFont, this))
        .mouseenter(__bind(this.activateFont, this))
        .mouseleave(__bind(this.deactivateFont, this));

        $('span', this.$select).click(__bind(this.toggleDrop, this));
        this.$arrow.click(__bind(this.toggleDrop, this));
      };

      Fontselect.prototype.toggleDrop = function(ev){

        if(this.active){
          this.$element.removeClass('font-select-active');
          this.$top = this.$results.scrollTop();
          this.$drop.hide();
          clearInterval(this.visibleInterval);

        } else {
          this.$element.addClass('font-select-active');
          this.$drop.show();
          this.$results.scrollTop(this.$top);
          this.moveToSelected();
          this.visibleInterval = setInterval(__bind(this.getVisibleFonts, this), 500);
        }

        this.active = !this.active;
      };

      Fontselect.prototype.selectFont = function(){

        var font = $('li.active', this.$results).data('value');
        this.$original.val(font).change();
        this.updateSelected();
        this.toggleDrop();
      };

      Fontselect.prototype.moveToSelected = function(){

        var $li, font = this.$original.val();

        if (font) {
          $li = $("li[data-value='"+ font +"']", this.$results);
        } else {
          $li = $("li", this.$results).first();
        }

        if (!$li.hasClass('active')) {
          this.$results.scrollTop(0);
          this.$results.scrollTop($li.addClass('active').position().top);
        }
      };

      Fontselect.prototype.activateFont = function(ev){
        $('li.active', this.$results).removeClass('active');
        $(ev.currentTarget).addClass('active');
      };

      Fontselect.prototype.deactivateFont = function(ev){

        $(ev.currentTarget).removeClass('active');
      };

      Fontselect.prototype.updateSelected = function(){

        var font = this.$original.val();
        $('span', this.$element).text(this.toReadable(font)).css(this.toStyle(font));
      };

      Fontselect.prototype.setupHtml = function(){

        this.$original.empty().hide();
        this.$element = $('<div>', {'class': this.options.style});
        this.$arrow = $('<div><b></b></div>');
        this.$select = $('<a><span>'+ this.options.placeholder +'</span></a>');
        this.$drop = $('<div>', {'class': 'fs-drop'});
        this.$results = $('<ul>', {'class': 'fs-results'});
        this.$original.after(this.$element.append(this.$select.append(this.$arrow)).append(this.$drop));
        this.$drop.append(this.$results.append(this.fontsAsHtml())).hide();
      };

      Fontselect.prototype.fontsAsHtml = function(){

        var fonts = this.options.fonts;
        var l = fonts.length;

        if (this.options.combine) {
          var combined = [];
          var name = '';
          var family = '';
          for (var i=0 ; i<l ; i++) {
            var parts = fonts[i].split(':');
            if (name == '' || name != parts[0]) {
              if (name != '') {
                combined.push(family);
              }
              name = parts[0];
              family = fonts[i];
            }
            else {
              family = family + '|' + fonts[i];
            }
            if (i == l-1) {
              combined.push(family);
            }
          }
          fonts = combined;
          l = fonts.length;
        }

        var r, s, h = '';

        for(var i=0; i<l; i++){
          r = this.toReadable(fonts[i]);
          s = this.toStyle(fonts[i]);
          //h += '<li data-value="'+ fonts[i] +'" style="font-family: '+s['font-family'] +'; font-weight: '+s['font-weight'] +'; font-style: '+s['font-style'] +'">'+ r +'</li>';
          h += '<li data-value="'+ fonts[i] +'">'+ r +'</li>';        
        }

        return h;
      };

      Fontselect.prototype.toReadable = function(font){
        var readable = font;
        if (this.options.combine) {
          readable = readable.replace(/:.*/, '');
        }
        return readable.replace(/[\+|:]/g, ' ');
      };

      Fontselect.prototype.toStyle = function(font){
        var t = font.split(':');
        var variant = t[1] || '';
        var weight = variant.match(/(?:[0-9]+|bold)/) ? variant.match(/(?:[0-9]+|bold)/)[0] : 400;
        var style = variant.match(/italic/) ? variant.match(/italic/)[0] : 'normal';

        return {'font-family': this.toReadable(t[0]), 'font-weight': weight, 'font-style': style};
      };

      Fontselect.prototype.getVisibleFonts = function(){

        if(this.$results.is(':hidden')) return;

        var fs = this;
        var top = this.$results.scrollTop();
        var bottom = top + this.$results.height();

        if(this.options.lookahead){
          var li = $('li', this.$results).first().height();
          bottom += li*this.options.lookahead;
        }

        $('li', this.$results).each(function(){

          var ft = $(this).position().top+top;
          var fb = ft + $(this).height();

          if ((fb >= top) && (ft <= bottom)){
            var font = $(this).data('value');
            fs.addFontLink(font);
          }

        });
      };

      Fontselect.prototype.addFontLink = function(font){

        var link = this.options.cssUrl + font;

        if ($("link[href*='" + font + "']").length === 0){
			$('link:last').after('<link href="' + link + '" rel="stylesheet" type="text/css">');
		}
      };

      return Fontselect;
    })();

    return this.each(function() {
      return new Fontselect(this, settings);
    });

  };
})(jQuery);
