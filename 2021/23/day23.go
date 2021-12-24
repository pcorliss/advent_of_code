package main

import (
	"container/heap"
	"fmt"
	"math"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("23/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 23")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

// From https://pkg.go.dev/container/heap
type Item struct {
	state    State
	priority int // The priority of the item in the queue.
	// The index is needed by update and is maintained by the heap.Interface methods.
	index int // The index of the item in the heap.
}

type PriorityQueue []*Item

func (pq PriorityQueue) Len() int { return len(pq) }

func (pq PriorityQueue) Less(i, j int) bool {
	// We want Pop to give us the highest, not lowest, priority so we use greater than here.
	return pq[i].priority < pq[j].priority
}

func (pq PriorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}

func (pq *PriorityQueue) Push(x interface{}) {
	n := len(*pq)
	item := x.(*Item)
	item.index = n
	*pq = append(*pq, item)
}

func (pq *PriorityQueue) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	old[n-1] = nil  // avoid memory leak
	item.index = -1 // for safety
	*pq = old[0 : n-1]
	return item
}

// update modifies the priority and value of an Item in the queue.
func (pq *PriorityQueue) update(item *Item, state State, priority int) {
	item.state = state
	item.priority = priority
	heap.Fix(pq, item.index)
}

type Point struct {
	x int
	y int
}

type State struct {
	energy  int
	steps   int
	lizards [8]Lizard
}

type Lizard struct {
	typ rune
	pos Point
}

var boardLookup = map[Point]rune{
	{1, 1}:  rune(0),  // Hallway Far Left
	{2, 1}:  rune(0),  // Hallway Almost Far Left
	{4, 1}:  rune(0),  // Between A/B
	{6, 1}:  rune(0),  // Between B/C
	{8, 1}:  rune(0),  // Between C/D
	{10, 1}: rune(0),  // Hallway Almost Far Right
	{11, 1}: rune(0),  // Hallway Far Right
	{3, 2}:  rune(65), // A Col
	{5, 2}:  rune(66), // B Col
	{7, 2}:  rune(67), // C Col
	{9, 2}:  rune(68), // D Col
	{3, 3}:  rune(65), // A Col
	{5, 3}:  rune(66), // B Col
	{7, 3}:  rune(67), // C Col
	{9, 3}:  rune(68), // D Col
}

func StringToState(input string) State {
	state := State{0, 0, [8]Lizard{}}
	charCount := make(map[rune]int)
	idx := 0
	for y, line := range strings.Split(input, "\n") {
		for x, char := range strings.Split(line, "") {
			if char != "." && char != "#" && char != " " {
				char := []rune(char)[0]
				charCount[char]++
				l := Lizard{char, Point{x, y}}
				state.lizards[idx] = l
				idx++
			}
		}
	}
	return state
}

func ValidEndState(state State) bool {
	for _, lizard := range state.lizards {
		if boardLookup[lizard.pos] != lizard.typ {
			return false
		}
	}
	return true
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func CalcDistance(beg, dest Point) int {
	x := int(math.Abs(float64(dest.x - beg.x)))
	y := beg.y - 1 + dest.y - 1
	return x + y
}

func ValidDest(state State, beg, dest Point) bool {
	correctRune, exists := boardLookup[dest]
	if !exists { // return false if the destination doesn't exist
		return false
	}

	// 3.0 rom the hallway it will stay in that spot until it can move into a room
	if beg.y == 1 && dest.y == 1 {
		return false
	}
	if beg.x == dest.x {
		return false
	}

	bottomOfColumnFilled := false
	bottomOfColumnCorrect := false
	freeToMoveVertically := true
	myLizard := Lizard{}
	// Is it blocked?
	// fmt.Println("Valid?:", beg, dest, state)
	for _, liz := range state.lizards {
		if dest == liz.pos {
			return false
		}

		// fmt.Println("  Liz:", liz)
		// Hallway Blocked
		if liz.pos.y == 1 {
			minX := min(beg.x, dest.x)
			maxX := max(beg.x, dest.x)
			// fmt.Println("Liz:", liz, beg, dest)
			if liz.pos.x > minX && liz.pos.x < maxX {
				return false
			}
		}
		if !bottomOfColumnFilled && liz.pos.y == 3 && liz.pos.x == dest.x {
			// fmt.Println("  Bottom Filled")
			bottomOfColumnFilled = true
		}

		if liz.pos == beg {
			// fmt.Println("MyLiz:", liz, beg)
			myLizard = liz
		}

		if liz.pos.x == dest.x && liz.pos.y == 3 && liz.typ == correctRune {
			bottomOfColumnCorrect = true
		}

		if liz.pos.x == beg.x && liz.pos.y < beg.y {
			freeToMoveVertically = false
		}
	}

	if beg.y == 3 && !freeToMoveVertically {
		return false
	}

	// Is this lizard allowed to move to this final spot?
	// fmt.Println("Correct:", correctRune, myLizard)
	if correctRune != 0 && correctRune != myLizard.typ {
		return false
	}

	if dest.y == 2 && !bottomOfColumnFilled {
		// Must move to bottom of column if column empty
		return false
	}

	if dest.y == 2 && !bottomOfColumnCorrect {
		// that room contains no amphipods which do not also have that room as their own destination.
		return false
	}

	// Can this Lizard go to this spot?
	// 2.0 will never move from the hallway into a room unless that room is their destination room
	return true
}

var energyLookup = map[rune]int{
	rune(65): 1,    // A Col
	rune(66): 10,   // B Col
	rune(67): 100,  // C Col
	rune(68): 1000, // D Col
}

func FindLowestEnergy(state State) int {
	pq := make(PriorityQueue, 1)
	pq[0] = &Item{
		state:    state,
		priority: 0,
		index:    0,
	}
	heap.Init(&pq)

	seen := make(map[[8]Lizard]bool)

	for pq.Len() > 0 {
		candidate := heap.Pop(&pq).(*Item)
		if ValidEndState(candidate.state) {
			return candidate.state.energy
		}

		if seen[candidate.state.lizards] {
			continue
		}
		seen[candidate.state.lizards] = true

		// if candidate.state.energy > 12521 {
		// 	return 0
		// }

		// debug := false
		// // if candidate.state.energy == 440 && candidate.state.steps == 2 {
		// // if candidate.state.steps == 3 {
		// if StateToString(candidate.state) == step1Str || StateToString(candidate.state) == step2Str || StateToString(candidate.state) == step3Str {
		// 	fmt.Println("Candidates:", pq.Len())
		// 	fmt.Println("Seen:", len(seen))
		// 	fmt.Println("Steps:", candidate.state.steps)
		// 	fmt.Println("Energy:", candidate.state.energy)
		// 	fmt.Println(StateToString(candidate.state))
		// 	debug = true
		// }

		// if pq.Len() == 27 {
		// 	debug = true
		// }

		// if debug {
		// 	fmt.Println("Heap Size:", pq.Len())
		// 	fmt.Println("Candidate:", candidate.state.energy)
		// 	fmt.Println(StateToString(candidate.state))
		// 	fmt.Println("")
		// }

		for _, lizard := range candidate.state.lizards {
			for dest, _ := range boardLookup {
				if ValidDest(candidate.state, lizard.pos, dest) {
					newLizards := [8]Lizard{}
					newEnergy := candidate.state.energy
					for i, l := range candidate.state.lizards {
						if l == lizard {
							newLizards[i] = Lizard{l.typ, dest}
							newEnergy += CalcDistance(lizard.pos, dest) * energyLookup[l.typ]
							// if debug && string(lizard.typ) == "C" {
							// 	fmt.Println("Pos:", l, lizard.pos, dest)
							// 	fmt.Println("Dist:", CalcDistance(lizard.pos, dest))
							// 	fmt.Println("NewEnergy:", newEnergy)
							// }
						} else {
							newLizards[i] = Lizard{l.typ, Point{l.pos.x, l.pos.y}}
						}
					}
					if newEnergy == 0 {
						panic("Invalid New Energy")
					}
					// if seen[newLizards] {
					// 	continue
					// }
					newState := State{newEnergy, candidate.state.steps + 1, newLizards}
					item := &Item{
						state:    newState,
						priority: newEnergy,
					}
					// if debug {
					// 	fmt.Println("Pushing New Candidate")
					// 	fmt.Println("Candidate:", newEnergy)
					// 	fmt.Println(StateToString(newState))
					// 	fmt.Println("")
					// }
					heap.Push(&pq, item)
				}
			}
		}
	}

	return 0
}

func StateToString(state State) string {
	lizards := make(map[Point]rune)
	for _, l := range state.lizards {
		lizards[l.pos] = l.typ
	}
	out := []string{}
	for y := 1; y < 4; y++ {
		line := ""
		for x := 0; x < 12; x++ {
			if r, exists := lizards[Point{x, y}]; exists {
				line += string(r)
			} else {
				line += "."
			}
		}
		out = append(out, line)
	}
	return strings.Join(out, "\n")
}

func Part1(input string) int {
	state := StringToState(input)
	return FindLowestEnergy(state)
}

func Part2(input string) int {
	return 0
}
