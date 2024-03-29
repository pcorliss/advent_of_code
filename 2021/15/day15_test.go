package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
`)

func TestGridConstruction(t *testing.T) {
	grid := StringToGrid(inputStr)
	assert.Equal(t, 1, grid.points[Point{0, 0}], "They should be equal")
	assert.Equal(t, 3, grid.points[Point{1, 1}], "They should be equal")
	assert.Equal(t, 1, grid.points[Point{9, 9}], "They should be equal")
	assert.Equal(t, 10, grid.width, "They should be equal")
	assert.Equal(t, 10, grid.height, "They should be equal")
}

func TestGridDuplicationSameStart(t *testing.T) {
	grid := StringToGridFive(inputStr, 10, 10)
	assert.Equal(t, 1, grid.points[Point{0, 0}], "They should be equal")
	assert.Equal(t, 3, grid.points[Point{1, 1}], "They should be equal")
	assert.Equal(t, 1, grid.points[Point{9, 9}], "They should be equal")
}

func TestGridDuplicationFiveTimesLarger(t *testing.T) {
	grid := StringToGridFive(inputStr, 10, 10)
	assert.Equal(t, 50, grid.width, "They should be equal")
	assert.Equal(t, 50, grid.height, "They should be equal")
}

func TestGridDuplication(t *testing.T) {
	grid := StringToGridFive(inputStr, 10, 10)
	assert.Equal(t, 2, grid.points[Point{10, 0}], "They should be equal")
	assert.Equal(t, 2, grid.points[Point{0, 10}], "They should be equal")

	assert.Equal(t, 3, grid.points[Point{10, 10}], "They should be equal")
	assert.Equal(t, 5, grid.points[Point{20, 20}], "They should be equal")
	assert.Equal(t, 7, grid.points[Point{30, 30}], "They should be equal")
	assert.Equal(t, 9, grid.points[Point{40, 40}], "They should be equal")

	assert.Equal(t, 9, grid.points[Point{49, 49}], "They should be equal")
}

func TestGridDuplicationOverflow(t *testing.T) {
	grid := StringToGridFive(inputStr, 10, 10)
	assert.Equal(t, 8, grid.points[Point{2, 1}], "They should be equal")
	assert.Equal(t, 9, grid.points[Point{2, 3}], "They should be equal")

	assert.Equal(t, 9, grid.points[Point{12, 1}], "They should be equal")
	assert.Equal(t, 9, grid.points[Point{2, 11}], "They should be equal")

	assert.Equal(t, 1, grid.points[Point{22, 1}], "They should be equal")
	assert.Equal(t, 1, grid.points[Point{2, 21}], "They should be equal")

	assert.Equal(t, 8, grid.points[Point{42, 43}], "They should be equal")
}

func TestNeighbors(t *testing.T) {
	p := Point{1, 1}
	assert.Equal(t, 4, len(Neighbors(p, 10, 10)), "They should be equal")
}

func TestNeighborsOnEdge(t *testing.T) {
	p := Point{9, 9}
	assert.Equal(t, 2, len(Neighbors(p, 10, 10)), "They should be equal")
	assert.Equal(t, Point{9, 8}, Neighbors(p, 10, 10)[0], "They should be equal")
	assert.Equal(t, Point{8, 9}, Neighbors(p, 10, 10)[1], "They should be equal")
}

func TestFindPathRisk(t *testing.T) {
	g := StringToGrid(inputStr)
	risk := FindPathRisk(g, Point{0, 0}, Point{9, 9})
	assert.Equal(t, 40, risk, "They should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 40, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 315, Part2(inputStr), "they should be equal")
}
