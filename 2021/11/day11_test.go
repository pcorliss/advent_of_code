package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
`)

func TestGridConstruction(t *testing.T) {
	grid := StringToGrid(inputStr)
	assert.Equal(t, 5, grid.points[Point{0, 0}], "They should be equal")
	assert.Equal(t, 7, grid.points[Point{1, 1}], "They should be equal")
	assert.Equal(t, 6, grid.points[Point{9, 9}], "They should be equal")
	assert.Equal(t, 10, grid.width, "They should be equal")
	assert.Equal(t, 10, grid.height, "They should be equal")
}

func TestNeighbors(t *testing.T) {
	p := Point{1, 1}
	assert.Equal(t, 8, len(Neighbors(p, 10, 10)), "They should be equal")
}

func TestNeighborsOnEdge(t *testing.T) {
	p := Point{9, 9}
	assert.Equal(t, 3, len(Neighbors(p, 10, 10)), "They should be equal")
	assert.Equal(t, Point{9, 8}, Neighbors(p, 10, 10)[0], "They should be equal")
	assert.Equal(t, Point{8, 9}, Neighbors(p, 10, 10)[1], "They should be equal")
}

func TestStepIncrements(t *testing.T) {
	grid := StringToGrid(inputStr)
	stepGrid := Step(grid)
	assert.Equal(t, 0, stepGrid.flashes, "they should be equal")
	assert.Equal(t, 6, stepGrid.points[Point{0, 0}], "they should be equal")
	assert.Equal(t, 7, stepGrid.points[Point{9, 9}], "they should be equal")
}

func TestStepFlashes(t *testing.T) {
	grid := StringToGrid(inputStr)
	stepGrid := Step(Step(grid))
	assert.Equal(t, 35, stepGrid.flashes, "they should be equal")
	assert.Equal(t, 0, stepGrid.points[Point{2, 0}], "they should be equal")
}

func TestStepMultipleFlashes(t *testing.T) {
	grid := StringToGrid(inputStr)
	for i := 0; i < 100; i++ {
		grid = Step(grid)
	}
	assert.Equal(t, 1656, grid.flashes, "they should be equal")
	assert.Equal(t, 0, grid.points[Point{0, 0}], "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 1656, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
