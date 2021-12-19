package main

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

var inputStr = strings.TrimSpace(`
[1,2]
[[1,2],3]
[9,[8,7]]
[[1,9],[8,5]]
[[[[1,2],[3,4]],[[5,6],[7,8]]],9]
[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]
`)

// If any pair is nested inside four pairs, the leftmost such pair explodes.
// If any regular number is 10 or greater, the leftmost such regular number splits.

func TestStringToTree(t *testing.T) {
	trees := StringToTree(inputStr)
	assert.Equal(t, 7, len(trees), "they should be equal")
}

func TestStringToTreeRegularNumbers(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[0]
	// fmt.Println("Tree:", tree, tree.left, tree.left.right)
	assert.Equal(t, 1, tree.left.data, "they should be equal")
	assert.Equal(t, 2, tree.right.data, "they should be equal")
}

func TestStringToTreeSingleNested(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[1]
	// fmt.Println("Tree:", tree, tree.left.left, tree.left.right, tree.right)
	assert.Equal(t, 1, tree.left.left.data, "they should be equal")
	assert.Equal(t, 2, tree.left.right.data, "they should be equal")
	assert.Equal(t, 3, tree.right.data, "they should be equal")
}

func TestStringToTreeSingleNestedRight(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[2]
	// fmt.Println("Tree:", tree, tree.left, tree.right)
	assert.Equal(t, 9, tree.left.data, "they should be equal")
	assert.Equal(t, 8, tree.right.left.data, "they should be equal")
	assert.Equal(t, 7, tree.right.right.data, "they should be equal")
}

func TestStringToTreeDoubleNested(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[3]
	// fmt.Println("Tree:", tree, tree.left, tree.right)
	assert.Equal(t, 1, tree.left.left.data, "they should be equal")
	assert.Equal(t, 9, tree.left.right.data, "they should be equal")
	assert.Equal(t, 8, tree.right.left.data, "they should be equal")
	assert.Equal(t, 5, tree.right.right.data, "they should be equal")
}

// [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
func TestStringToTreeQuadNested(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[4]
	assert.Equal(t, 1, tree.left.left.left.left.data, "they should be equal")
	assert.Equal(t, 2, tree.left.left.left.right.data, "they should be equal")
	assert.Equal(t, 3, tree.left.left.right.left.data, "they should be equal")
	assert.Equal(t, 4, tree.left.left.right.right.data, "they should be equal")
	assert.Equal(t, 5, tree.left.right.left.left.data, "they should be equal")
	assert.Equal(t, 6, tree.left.right.left.right.data, "they should be equal")
	assert.Equal(t, 7, tree.left.right.right.left.data, "they should be equal")
	assert.Equal(t, 8, tree.left.right.right.right.data, "they should be equal")
	assert.Equal(t, 9, tree.right.data, "they should be equal")
}

// [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
func TestStringToTreeComplex(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[5]
	assert.Equal(t, 9, tree.left.left.left.data, "they should be equal")
	assert.Equal(t, 3, tree.left.left.right.left.data, "they should be equal")
	assert.Equal(t, 8, tree.left.left.right.right.data, "they should be equal")

	assert.Equal(t, 0, tree.left.right.left.left.data, "they should be equal")
	assert.Equal(t, 9, tree.left.right.left.right.data, "they should be equal")
	assert.Equal(t, 6, tree.left.right.right.data, "they should be equal")

	assert.Equal(t, 3, tree.right.left.left.left.data, "they should be equal")
	assert.Equal(t, 7, tree.right.left.left.right.data, "they should be equal")
	assert.Equal(t, 4, tree.right.left.right.left.data, "they should be equal")
	assert.Equal(t, 9, tree.right.left.right.right.data, "they should be equal")

	assert.Equal(t, 3, tree.right.right.data, "they should be equal")
}

func TestTreeToString(t *testing.T) {
	trees := StringToTree(inputStr)
	tree := trees[5]
	expected := "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]"
	assert.Equal(t, expected, TreeToString(*tree), "they should be equal")
}

var explodeTests = []struct {
	input       string
	expected    string
	description string
}{
	{"[[[[[9,8],1],2],3],4]", "[[[[0,9],2],3],4]", "(the 9 has no regular number to its left, so it is not added to any regular number)."},
	{"[7,[6,[5,[4,[3,2]]]]]", "[7,[6,[5,[7,0]]]]", "(the 2 has no regular number to its right, and so it is not added to any regular number)."},
	{"[[6,[5,[4,[3,2]]]],1]", "[[6,[5,[7,0]]],3]", ""},
	{"[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", "(the pair [3,2] is unaffected because the pair [7,3] is further to the left; [3,2] would explode on the next action)."},
	{"[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[7,0]]]]", ""},
	{"[[[[0,7],4],[7,[[8,4],9]]],[1,1]]", "[[[[0,7],4],[15,[0,13]]],[1,1]]", "complex explode"},
}

func TestTreeExplode(t *testing.T) {
	for _, tt := range explodeTests {
		t.Run(tt.description, func(t *testing.T) {
			trees := StringToTree(tt.input)
			tree := trees[0]
			actual := TreeToString(TreeExplode(*tree))
			if actual != tt.expected {
				t.Errorf("TreeExplode(%s) got %s, want %s", tt.input, actual, tt.expected)
			}
		})
	}
}

var splitTests = []struct {
	input       string
	expected    string
	description string
}{
	{"[[[[[0,9],9],0],0],0]", "[[[[0,[9,9]],0],0],0]", "Even Numbers"},
	{"[[[[[0,8],9],0],0],0]", "[[[[0,[8,9]],0],0],0]", "Odd Numbers"},
}

func TestTreeSplit(t *testing.T) {
	for _, tt := range splitTests {
		t.Run(tt.description, func(t *testing.T) {
			trees := StringToTree(tt.input)
			tree := trees[0]
			explodedTree := TreeExplode(*tree)
			actual := TreeToString(TreeSplit(explodedTree))
			if actual != tt.expected {
				t.Errorf("TreeSplit(%s) got %s, want %s", tt.input, actual, tt.expected)
			}
		})
	}
}

var addStr = strings.TrimSpace(`
[[[[4,3],4],4],[7,[[8,4],9]]]
[1,1]
`)

func TestTreeAdd(t *testing.T) {
	trees := StringToTree(addStr)
	tree := TreeAdd(trees)

	expected := "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"
	assert.Equal(t, expected, TreeToString(tree), "they should be equal")
}

func TestTreeReduce(t *testing.T) {
	trees := TreeAdd(StringToTree(addStr))
	tree := TreeReduce(trees)

	expected := "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
	assert.Equal(t, expected, TreeToString(tree), "they should be equal")
}

var bigReduce = strings.TrimSpace(`
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
`)

func TestFinalSum(t *testing.T) {
	trees := TreeAddAndReduce(StringToTree(bigReduce))
	expected := "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"

	assert.Equal(t, expected, TreeToString(trees), "they should be equal")
}

var magTests = []struct {
	input       string
	expected    int
	description string
}{
	{"[9,1]", 29, "Simple"},
	{"[[9,1],[1,9]]", 129, "Nested"},
	{"[[1,2],[[3,4],5]]", 143, ""},
	{"[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", 1384, ""},
	{"[[[[1,1],[2,2]],[3,3]],[4,4]]", 445, ""},
	{"[[[[3,0],[5,3]],[4,4]],[5,5]]", 791, ""},
	{"[[[[5,0],[7,4]],[5,5]],[6,6]]", 1137, ""},
	{"[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", 3488, ""},
}

func TestTreeMagnitude(t *testing.T) {
	for _, tt := range magTests {
		t.Run(tt.description, func(t *testing.T) {
			trees := StringToTree(tt.input)
			tree := trees[0]
			actual := TreeMagnitude(*tree)
			if actual != tt.expected {
				t.Errorf("TreeMagnitude(%s) got %d, want %d", tt.input, actual, tt.expected)
			}
		})
	}
}

var sampleIn = strings.TrimSpace(`
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
`)

func TestPart1(t *testing.T) {
	assert.Equal(t, 4140, Part1(sampleIn), "they should be equal")
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 3993, Part2(sampleIn), "they should be equal")
}
