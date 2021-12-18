package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`target area: x=20..30, y=-10..-5`)

func TestStringToTarget(t *testing.T) {
	target := StringToTarget(inputStr)
	assert.Equal(t, 20, target.x_start, "they should be equal")
	assert.Equal(t, 30, target.x_end, "they should be equal")
	assert.Equal(t, -10, target.y_start, "they should be equal")
	assert.Equal(t, -5, target.y_end, "they should be equal")
}

func TestPointInTarget(t *testing.T) {
	target := StringToTarget(inputStr)
	assert.Equal(t, true, PointInTarget(Point{20, -10}, target), "they should be equal")
	assert.Equal(t, true, PointInTarget(Point{30, -5}, target), "they should be equal")
	assert.Equal(t, false, PointInTarget(Point{31, -5}, target), "they should be equal")
	assert.Equal(t, false, PointInTarget(Point{30, -4}, target), "they should be equal")
}

func TestIntersectsTarget(t *testing.T) {
	target := StringToTarget(inputStr)
	boo, max := IntersectsTarget(Point{7, 2}, target)
	assert.Equal(t, true, boo, "they should be equal")
	assert.Equal(t, 3, max, "they should be equal")
	boo, max = IntersectsTarget(Point{6, 3}, target)
	assert.Equal(t, true, boo, "they should be equal")
	assert.Equal(t, 6, max, "they should be equal")
	boo, max = IntersectsTarget(Point{9, 0}, target)
	assert.Equal(t, true, boo, "they should be equal")
	assert.Equal(t, 0, max, "they should be equal")
	boo, max = IntersectsTarget(Point{17, -4}, target)
	assert.Equal(t, false, boo, "they should be equal")
	assert.Equal(t, 0, max, "they should be equal")
}

func TestMaxVel(t *testing.T) {
	target := StringToTarget(inputStr)
	// boo, max := IntersectsTarget(Point{6, 9}, target)
	// fmt.Println("Boo:", boo, "Max:", max)
	p, maxY := MaxVel(target)
	assert.Equal(t, Point{6, 9}, p, "they should be equal")
	assert.Equal(t, 45, maxY, "they should be equal")
}

func TestPart1(t *testing.T) {
	assert.Equal(t, 45, Part1(inputStr), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
