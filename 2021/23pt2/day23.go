package main

import (
	"container/heap"
	"fmt"
	"math"
	"os"
	"sort"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("23pt2/input.txt")
	if err != nil {
		panic(err)
	}

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

const LIZARDSIZE = 16

type State struct {
	energy  int
	steps   int
	lizards [LIZARDSIZE]Lizard
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
	{3, 4}:  rune(65), // A Col
	{5, 4}:  rune(66), // B Col
	{7, 4}:  rune(67), // C Col
	{9, 4}:  rune(68), // D Col
	{3, 5}:  rune(65), // A Col
	{5, 5}:  rune(66), // B Col
	{7, 5}:  rune(67), // C Col
	{9, 5}:  rune(68), // D Col
}

func StringToState(input string) State {
	state := State{0, 0, [LIZARDSIZE]Lizard{}}
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

	// fmt.Println("A")
	// bottomOfColumnFilled := false
	// bottomOfColumnCorrect := false
	// freeToMoveVertically := true
	myLizard := Lizard{}
	minCol := 6
	// fmt.Println("Valid?:", beg, dest, state)
	for _, liz := range state.lizards {
		if dest == liz.pos {
			return false
		}

		if liz.pos.x == dest.x {
			if liz.pos.y < dest.y {
				return false
			}
			if liz.typ != correctRune {
				return false
			}
			if liz.pos.y < minCol {
				minCol = liz.pos.y
			}
		}

		if liz.pos.x == beg.x && liz.pos.y < beg.y {
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
		// if !bottomOfColumnFilled && liz.pos.y == 3 && liz.pos.x == dest.x {
		// 	// fmt.Println("  Bottom Filled")
		// 	bottomOfColumnFilled = true
		// }

		if liz.pos == beg {
			// fmt.Println("MyLiz:", liz, beg)
			myLizard = liz
		}

		// if liz.pos.x == dest.x && liz.pos.y == 3 && liz.typ == correctRune {
		// 	bottomOfColumnCorrect = true
		// }

		// if liz.pos.x == beg.x && liz.pos.y < beg.y {
		// 	// freeToMoveVertically = false
		// }
	}
	// fmt.Println("B", dest.y, minCol-1)
	if dest.y != 1 && dest.y < minCol-1 {
		return false
	}
	// if beg.y == 3 && !freeToMoveVertically {
	// 	return false
	// }
	// fmt.Println("C")
	// Is this lizard allowed to move to this final spot?
	// fmt.Println("Correct:", correctRune, myLizard)
	if correctRune != 0 && correctRune != myLizard.typ {
		return false
	}

	// fmt.Println("D")
	// if dest.y == 2 && !bottomOfColumnFilled {
	// 	// Must move to bottom of column if column empty
	// 	return false
	// }

	// if dest.y == 2 && !bottomOfColumnCorrect {
	// 	// that room contains no amphipods which do not also have that room as their own destination.
	// 	return false
	// }

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

var stepAStr = StateToString(StringToState(strings.TrimSpace(`
#############
#..........D#
###B#C#B#.###
  #D#C#B#A#
  #D#B#A#C#
  #A#D#C#A#
  #########
`)))

var stepBStr = StateToString(StringToState(strings.TrimSpace(`
#############
#A.........D#
###B#C#B#.###
  #D#C#B#.#
  #D#B#A#C#
  #A#D#C#A#
  #########
`)))

var stepCStr = StateToString(StringToState(strings.TrimSpace(`
#############
#A........BD#
###B#C#.#.###
  #D#C#B#.#
  #D#B#A#C#
  #A#D#C#A#
  #########
`)))
var stepDStr = StateToString(StringToState(strings.TrimSpace(`
#############
#A......B.BD#
###B#C#.#.###
  #D#C#.#.#
  #D#B#A#C#
  #A#D#C#A#
  #########
`)))

var stepEStr = StateToString(StringToState(strings.TrimSpace(`
#############
#AA.....B.BD#
###B#C#.#.###
  #D#C#.#.#
  #D#B#.#C#
  #A#D#C#A#
  #########
`)))
var stepFStr = StateToString(StringToState(strings.TrimSpace(`
#############
#AA.....B.BD#
###B#.#.#.###
  #D#C#.#.#
  #D#B#C#C#
  #A#D#C#A#
  #########
`)))

var stepGStr = StateToString(StringToState(strings.TrimSpace(`
#############
#AA.....B.BD#
###B#.#.#.###
  #D#.#C#.#
  #D#B#C#C#
  #A#D#C#A#
  #########
`)))

var stepHStr = StateToString(StringToState(strings.TrimSpace(`
#############
#AA...B.B.BD#
###B#.#.#.###
  #D#.#C#.#
  #D#.#C#C#
  #A#D#C#A#
  #########
`)))

var stepIStr = StateToString(StringToState(strings.TrimSpace(`
#############
#AA.D.B.B.BD#
###B#.#.#.###
  #D#.#C#.#
  #D#.#C#C#
  #A#.#C#A#
  #########
`)))

var stepJStr = StateToString(StringToState(strings.TrimSpace(`
#############
#AA.D...B.BD#
###B#.#.#.###
  #D#.#C#.#
  #D#.#C#C#
  #A#B#C#A#
  #########
`)))

func FindLowestEnergy(state State) int {
	pq := make(PriorityQueue, 1)
	pq[0] = &Item{
		state:    state,
		priority: 0,
		index:    0,
	}
	heap.Init(&pq)

	seen := make(map[[LIZARDSIZE]Lizard]bool)

	for pq.Len() > 0 {
		candidate := heap.Pop(&pq).(*Item)
		if ValidEndState(candidate.state) {
			return candidate.state.energy
		}

		if seen[candidate.state.lizards] {
			continue
		}
		seen[candidate.state.lizards] = true

		if candidate.state.energy > 441690 {
			fmt.Println("Too Large Energy")
			fmt.Println("Len:", pq.Len())
			return -1
		}

		debug := false
		_ = debug
		// // if candidate.state.energy == 440 && candidate.state.steps == 2 {
		// // if candidate.state.steps == 3 {
		// if StateToString(candidate.state) == stepAStr {
		// if candidate.state.steps == 1 && candidate.state.energy == 3000 {
		// if candidate.state.steps == 1 && StateToString(candidate.state) == stepAStr {
		// 	debug = true
		// }
		// if candidate.state.steps == 2 && StateToString(candidate.state) == stepBStr {
		// 	debug = true
		// }
		// if candidate.state.steps == 3 && StateToString(candidate.state) == stepCStr {
		// 	debug = true
		// }
		// if candidate.state.steps == 4 && StateToString(candidate.state) == stepDStr {
		// 	debug = true
		// }
		// if candidate.state.steps == 5 && StateToString(candidate.state) == stepEStr {
		// 	debug = true
		// }
		// if candidate.state.energy == 3688 && StateToString(candidate.state) == stepFStr {
		// 	debug = true
		// }
		// if candidate.state.energy == 4288 && StateToString(candidate.state) == stepGStr {
		// 	debug = true
		// }
		// if candidate.state.energy == 4328 && StateToString(candidate.state) == stepHStr {
		// 	debug = true
		// }
		// if candidate.state.energy == 9328 && StateToString(candidate.state) == stepIStr {
		// 	debug = true
		// }
		// if candidate.state.energy == 9378 && StateToString(candidate.state) == stepJStr {
		// 	debug = true
		// }
		// if debug {
		// 	fmt.Println("Candidates:", pq.Len())
		// 	fmt.Println("Seen:", len(seen))
		// 	fmt.Println("Steps:", candidate.state.steps)
		// 	fmt.Println("Energy:", candidate.state.energy)
		// 	fmt.Println(StateToString(candidate.state))
		// 	// 	// 	debug = true
		// }

		// if candidate.state.steps >= 1 {
		// 	return -3
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
					newLizards := [LIZARDSIZE]Lizard{}
					newEnergy := candidate.state.energy
					for i, l := range candidate.state.lizards {
						if l == lizard {
							newLizards[i] = Lizard{l.typ, dest}
							newEnergy += CalcDistance(lizard.pos, dest) * energyLookup[l.typ]
							// if debug && string(lizard.typ) == "B" {
							// 	fmt.Println("Pos:", l, lizard.pos, dest)
							// 	fmt.Println("Dist:", CalcDistance(lizard.pos, dest))
							// 	fmt.Println("NewEnergy:", newEnergy)
							// }
						} else {
							newLizards[i] = Lizard{l.typ, Point{l.pos.x, l.pos.y}}
						}
					}
					if newEnergy == 0 {
						fmt.Println("Candidate:", candidate.state)
						panic("Invalid New Energy")
					}
					// Seems to speed up by about 4x, likely getting rid of dupes
					sort.Slice(newLizards[:], func(i, j int) bool {
						return (newLizards[i].pos.y*10 + newLizards[i].pos.x) < (newLizards[j].pos.y*10 + newLizards[j].pos.x)
					})
					// if seen[newLizards] {
					// 	continue
					// }
					newState := State{newEnergy, candidate.state.steps + 1, newLizards}
					item := &Item{
						state:    newState,
						priority: newEnergy,
					}
					// if debug && string(lizard.typ) == "B" {
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

	fmt.Println("Unable to find valid end state")
	return -2
}

func StateToString(state State) string {
	lizards := make(map[Point]rune)
	for _, l := range state.lizards {
		lizards[l.pos] = l.typ
	}
	out := []string{}
	for y := 1; y < 6; y++ {
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
	state := StringToState(input)
	return FindLowestEnergy(state)
}
