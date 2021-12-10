package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
2199943210
3987894921
9856789892
8767896789
9899965678
`)

func TestGridConstruction(t *testing.T) {
	grid := StringToGrid(inputStr)
	assert.Equal(t, 2, grid.points[Point{0, 0}], "They should be equal")
	assert.Equal(t, 9, grid.points[Point{1, 1}], "They should be equal")
	assert.Equal(t, 8, grid.points[Point{9, 4}], "They should be equal")
	assert.Equal(t, 10, grid.width, "They should be equal")
	assert.Equal(t, 5, grid.height, "They should be equal")
}

func TestNeighbors(t *testing.T) {
	p := Point{1, 1}
	assert.Equal(t, 4, len(Neighbors(p, 10, 10)), "They should be equal")
	assert.Equal(t, Point{1, 0}, Neighbors(p, 10, 10)[0], "They should be equal")
	assert.Equal(t, Point{2, 1}, Neighbors(p, 10, 10)[1], "They should be equal")
	assert.Equal(t, Point{1, 2}, Neighbors(p, 10, 10)[2], "They should be equal")
	assert.Equal(t, Point{0, 1}, Neighbors(p, 10, 10)[3], "They should be equal")
}

func TestNeighborsOnEdge(t *testing.T) {
	p := Point{9, 9}
	assert.Equal(t, 2, len(Neighbors(p, 10, 10)), "They should be equal")
	assert.Equal(t, Point{9, 8}, Neighbors(p, 10, 10)[0], "They should be equal")
	assert.Equal(t, Point{8, 9}, Neighbors(p, 10, 10)[1], "They should be equal")
}

func TestLowPOints(t *testing.T) {
	g := StringToGrid(inputStr)
	low := LowPoints(g)
	// fmt.Println(low)
	assert.Equal(t, 4, len(low), "They should be equal")
	// Order is non-determinant
	// assert.Equal(t, Point{1, 0}, low[0], "They should be equal")
	// assert.Equal(t, Point{9, 0}, low[1], "They should be equal")
	// assert.Equal(t, Point{2, 2}, low[2], "They should be equal")
	// assert.Equal(t, Point{6, 4}, low[3], "They should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 15, Part1(inputStr), "they should be equal")
}

func TestBasinSize(t *testing.T) {
	g := StringToGrid(inputStr)
	p := Point{1, 0}
	assert.Equal(t, 3, BasinSize(p, g), "They should be equal")
}
func TestBasinBigSize(t *testing.T) {
	g := StringToGrid(inputStr)
	p := Point{2, 2}
	assert.Equal(t, 14, BasinSize(p, g), "They should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 1134, Part2(inputStr), "they should be equal")
}
