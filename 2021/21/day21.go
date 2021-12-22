package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("21/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 21")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Player struct {
	pos   int
	score int
}

func StringToStarts(input string) []Player {
	players := make([]Player, 2)
	lines := strings.Split(input, "\n")
	for i, line := range lines {
		parts := strings.Split(line, " ")
		n, err := strconv.Atoi(parts[4])
		if err != nil {
			panic(err)
		}
		players[i].pos = n
	}
	return players
}

func PlayRounds(players []Player, rounds int) ([]Player, int) {
	die := 0
	rollCount := 0
	for i := 0; i < rounds; i++ {
		rollCount += 3
		p := players[i%2] // This is a copy, maybe should be a reference
		for j := 0; j < 3; j++ {
			die = (die + 1) % 100
			p.pos += die
		}
		for p.pos > 10 {
			p.pos -= 10
		}
		p.score += p.pos
		players[i%2] = p

		if p.score >= 1000 {
			break
		}
	}
	return players, rollCount
}

var rollDist = [27]int{3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 9}

var rollMap = map[int]int{
	3: 1,
	4: 3,
	5: 6,
	6: 7,
	7: 6,
	8: 3,
	9: 1,
}

func PlayQuantumRounds(players []Player, score int) (int, int) {
	countA := 0
	countB := 0
	// for _, roll := range rollDist {
	// 	p := players[0]
	// 	p.pos += roll
	// 	for p.pos > 10 {
	// 		p.pos -= 10
	// 	}
	// 	p.score += p.pos
	// 	if p.score >= score {
	// 		countA++
	// 	} else {
	// 		for _, roll2 := range rollDist {
	// 			p2 := players[1]
	// 			p2.pos += roll2
	// 			for p2.pos > 10 {
	// 				p2.pos -= 10
	// 			}
	// 			p2.score += p2.pos
	// 			if p2.score >= score {
	// 				countB++
	// 			} else {
	// 				a, b := PlayQuantumRounds([]Player{p, p2}, score)
	// 				countA += a
	// 				countB += b
	// 			}
	// 		}
	// 	}
	// }
	for roll, mult := range rollMap {
		p := players[0]
		p.pos += roll
		for p.pos > 10 {
			p.pos -= 10
		}
		p.score += p.pos
		if p.score >= score {
			countA += mult
		} else {
			for roll2, mult2 := range rollMap {
				p2 := players[1]
				p2.pos += roll2
				for p2.pos > 10 {
					p2.pos -= 10
				}
				p2.score += p2.pos
				if p2.score >= score {
					countB += mult * mult2
				} else {
					a, b := PlayQuantumRounds([]Player{p, p2}, score)
					countA += a * mult * mult2
					countB += b * mult * mult2
				}
			}
		}
	}

	return countA, countB
}

func Part1(input string) int {
	players := StringToStarts(input)
	p, rolls := PlayRounds(players, 332)
	loser := p[0]
	if loser.score == 1000 {
		loser = p[1]
	}
	return rolls * p[1].score
}

func Part2(input string) int {
	players := StringToStarts(input)
	a, b := PlayQuantumRounds(players, 21)
	fmt.Println("A:", a, "B:", b)
	return a
}
