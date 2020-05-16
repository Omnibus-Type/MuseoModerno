#!/bin/sh
set -e

 echo "Generating Static fonts"
 mkdir -p ../fonts/TTF/
 fontmake -g MuseoModerno.glyphs -i -o ttf --output-dir ../fonts/TTF/
 
 echo "Generating VFs"
 fontmake -g MuseoModerno.glyphs -o variable --output-path ../fonts/TTF/MuseoModerno\[wght\].ttf
 
 rm -rf master_ufo/ instance_ufo/
 echo "Post processing"


ttfs=$(ls ../fonts/TTF/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
	./ttfautohint-vf $ttf "$ttf.fix";
	mv "$ttf.fix" $ttf;
done

vfs=$(ls ../fonts/TTF/*-VF.ttf)
for vf in $vfs
do
	gftools fix-dsig -f $vf;
	./ttfautohint-vf --stem-width-mode nnn $ttf "$ttf.fix";
	mv "$vf.fix" $vf;
done

gftools fix-vf-meta $vfs;
for vf in $vfs
do
	mv "$vf.fix" $vf;
done

echo "QAing"
gftools qa ../fonts/TTF/*\[wght\].ttf -gf -o ../qa --fontbakery --diffenator --diffbrowsers