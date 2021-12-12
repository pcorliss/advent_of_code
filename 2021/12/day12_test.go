package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

// 10 paths
var inputStr = strings.TrimSpace(`
start-A
start-b
A-c
A-b
b-d
A-end
b-end
`)

// 19 paths
var medEx = strings.TrimSpace(`
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
`)

// 226 paths
var largeEx = strings.TrimSpace(`
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
`)

func TestSmallCave(t *testing.T) {
	assert.Equal(t, true, smallCave("a"), "they should be equal")
	assert.Equal(t, false, smallCave("A"), "they should be equal")
}

func TestStringToGraph(t *testing.T) {
	graph := StringToGraph(inputStr)
	assert.Equal(t, true, graph.edges[Edge{"start", "A"}], "they should be equal")
	assert.Equal(t, true, graph.edges[Edge{"A", "c"}], "they should be equal")
	assert.Equal(t, true, graph.edges[Edge{"b", "d"}], "they should be equal")
}

func TestStringToGraphOpposites(t *testing.T) {
	graph := StringToGraph(inputStr)
	assert.Equal(t, true, graph.edges[Edge{"c", "A"}], "they should be equal")
	assert.Equal(t, true, graph.edges[Edge{"d", "b"}], "they should be equal")
}

func TestStringToGraphStartUnidirectional(t *testing.T) {
	graph := StringToGraph(inputStr)
	assert.Equal(t, false, graph.edges[Edge{"A", "start"}], "they should be equal")
	assert.Equal(t, false, graph.edges[Edge{"end", "A"}], "they should be equal")
}

func TestPart1(t *testing.T) {
	// assert.Equal(t, 10, Part1(inputStr), "they should be equal")
	// assert.Equal(t, 19, Part1(medEx), "they should be equal")
	// assert.Equal(t, 226, Part1(largeEx), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 0, Part2(inputStr), "they should be equal")
}
