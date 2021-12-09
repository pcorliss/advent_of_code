package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
`)

func TestPart1(t *testing.T) {
	assert.Equal(t, 26, Part1(inputStr), "they should be equal")
}

func TestDeduceFindsEasyMaps(t *testing.T) {
	str := "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
	signal := StringToSignals(str)[0]
	assert.Equal(t, 1, Deduce(signal)["ab"], "they should be equal")
	assert.Equal(t, 4, Deduce(signal)["abef"], "they should be equal")
	assert.Equal(t, 7, Deduce(signal)["abd"], "they should be equal")
	assert.Equal(t, 8, Deduce(signal)["abcdefg"], "they should be equal")
}

func TestDeduceFindsHardMapsSizeFive(t *testing.T) {
	str := "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
	signal := StringToSignals(str)[0]
	assert.Equal(t, 5, Deduce(signal)["bcdef"], "they should be equal")
	assert.Equal(t, 2, Deduce(signal)["acdfg"], "they should be equal")
	assert.Equal(t, 3, Deduce(signal)["abcdf"], "they should be equal")
}

func TestDeduceFindsHardMapsSizeSix(t *testing.T) {
	str := "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
	signal := StringToSignals(str)[0]
	assert.Equal(t, 0, Deduce(signal)["abcdeg"], "they should be equal")
	assert.Equal(t, 6, Deduce(signal)["bcdefg"], "they should be equal")
	assert.Equal(t, 9, Deduce(signal)["abcdef"], "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 61229, Part2(inputStr), "they should be equal")
}
