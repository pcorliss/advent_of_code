package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
`)

func TestStringToGrid(t *testing.T) {
	_, grid := StringToGrid(inputStr)
	assert.Equal(t, true, grid.points[Point{0, 0}], "they should be equal")
	assert.Equal(t, false, grid.points[Point{1, 1}], "they should be equal")
	assert.Equal(t, true, grid.points[Point{4, 4}], "they should be equal")
	assert.Equal(t, Point{4, 4}, grid.max, "they should be equal")
	assert.Equal(t, Point{0, 0}, grid.min, "they should be equal")

}

func TestStringToGridLookup(t *testing.T) {
	lookup, _ := StringToGrid(inputStr)
	assert.Equal(t, 512, len(lookup), "they should be equal")
	assert.Equal(t, false, lookup[0], "they should be equal")
	assert.Equal(t, false, lookup[1], "they should be equal")
	assert.Equal(t, true, lookup[2], "they should be equal")
}

func TestNeighbors(t *testing.T) {
	p := Point{1, 1}
	assert.Equal(t, 9, len(Neighbors(p)), "They should be equal")
}

func TestGridToString(t *testing.T) {
	_, grid := StringToGrid(inputStr)
	expected := strings.TrimSpace(`
#..#.
#....
##..#
..#..
..###
	`)
	assert.Equal(t, expected, GridToString(grid), "They should be equal")
}

func TestStep(t *testing.T) {
	lookup, grid := StringToGrid(inputStr)
	expected := strings.TrimSpace(`
.##.##.
#..#.#.
##.#..#
####..#
.#..##.
..##..#
...#.#.
`)
	grid = Step(grid, lookup)
	assert.Equal(t, Point{-1, -1}, grid.min, "They should be equal")
	assert.Equal(t, Point{5, 5}, grid.max, "They should be equal")
	assert.Equal(t, expected, GridToString(grid), "They should be equal")
}

func TestStep2(t *testing.T) {
	lookup, grid := StringToGrid(inputStr)
	expected := strings.TrimSpace(`
.......#.
.#..#.#..
#.#...###
#...##.#.
#.....#.#
.#.#####.
..#.#####
...##.##.
....###..
`)
	grid = Step(grid, lookup)
	grid = Step(grid, lookup)
	assert.Equal(t, Point{-2, -2}, grid.min, "They should be equal")
	assert.Equal(t, Point{6, 6}, grid.max, "They should be equal")
	assert.Equal(t, expected, GridToString(grid), "They should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 35, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 3351, Part2(inputStr), "they should be equal")
}
