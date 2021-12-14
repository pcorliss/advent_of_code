package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
`)

func TestCreatesGrid(t *testing.T) {
	g := StringToGrid(inputStr)
	assert.Equal(t, true, g.points[Point{6, 10}], "they should be equal")
	assert.Equal(t, true, g.points[Point{0, 14}], "they should be equal")
	assert.Equal(t, true, g.points[Point{9, 0}], "they should be equal")
}

func TestCreatesGridFolds(t *testing.T) {
	g := StringToGrid(inputStr)
	assert.Equal(t, Fold{"y", 7}, g.folds[0], "they should be equal")
	assert.Equal(t, Fold{"x", 5}, g.folds[1], "they should be equal")
}

func TestCreatesGridDims(t *testing.T) {
	g := StringToGrid(inputStr)
	assert.Equal(t, 11, g.width, "they should be equal")
	assert.Equal(t, 15, g.height, "they should be equal")
}

var expectedStep0 = strings.TrimSpace(`
...#..#..#.
....#......
...........
#..........
...#....#.#
...........
...........
...........
...........
...........
.#....#.##.
....#......
......#...#
#..........
#.#........
`)

var expectedStep1 = strings.TrimSpace(`
#.##..#..#.
#...#......
......#...#
#...#......
.#.#..#.###
...........
...........
`)

var expectedStep2 = strings.TrimSpace(`
#####
#...#
#...#
#...#
#####
.....
.....
`)

func TestGridToString(t *testing.T) {
	g := StringToGrid(inputStr)
	assert.Equal(t, expectedStep0, GridToString(g), "they should be equal")
}

func TestGridCount(t *testing.T) {
	g := StringToGrid(inputStr)
	assert.Equal(t, 18, len(g.points), "they should be equal")
}

func TestFold(t *testing.T) {
	startGrid := StringToGrid(inputStr)
	g := FoldGrid(startGrid)
	assert.Equal(t, 17, len(g.points), "they should be equal")
	assert.Equal(t, expectedStep1, GridToString(g), "they should be equal")
}

func TestFold2(t *testing.T) {
	startGrid := StringToGrid(inputStr)
	g := FoldGrid(startGrid)
	g = FoldGrid(g)
	assert.Equal(t, 16, len(g.points), "they should be equal")
	assert.Equal(t, expectedStep2, GridToString(g), "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 17, Part1(inputStr), "they should be equal")
}

// func TestPart2(t *testing.T) {
// 	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
// }
