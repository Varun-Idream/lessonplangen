import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lessonplan/presentation/core/custom_button.dart';
import 'package:lessonplan/presentation/lessonplan/functions.dart';
import 'package:lessonplan/util/constants/color_constants.dart';

@RoutePage()
class PdfExportPage extends StatelessWidget {
  const PdfExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryWhite,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomButton(
              title: 'Export',
              onTap: () {
                LessonPlanFunctions.processPDF(
                  generatedData: {
                    "id": "a3878916-4b19-4404-9e73-0bd7a4afe428",
                    "board": {
                      "id": "087c80b0-ac25-40ee-8657-28b694882ba8",
                      "name": "CBSE"
                    },
                    "grade": {
                      "id": "65955148-e106-461b-a9a6-e0c3294f6734",
                      "name": "Grade 10"
                    },
                    "section": null,
                    "subject": {
                      "id": "abf49127-253c-4dc9-9bf5-eb66360e5592",
                      "name": "Mathematics"
                    },
                    "status": "Completed",
                    "duration_minutes": 30,
                    "topic": "Trigonometry",
                    "documents": [],
                    "audio": null,
                    "subject_matter": {
                      "topics_to_be_covered": {
                        "topic": {
                          "ai_recommendations": [
                            "Introduce the concept of trigonometric ratios focusing on acute angles in right triangles, aligning with definitions and examples provided, such as the Qutub Minar scenario.",
                            "Teach calculation of basic trigonometric ratios (sine, cosine, tangent) for specific angles (0°, 30°, 45°, 60°, 90°), including the understanding of the sides relative to the chosen angle.",
                            "Explain and prove fundamental trigonometric identities, starting from the primary identity relating sine and cosine, including proof examples based on right-angled triangle properties."
                          ],
                          "additional_recommendations": [
                            "Incorporate historical context of trigonometry origin and application in astronomy and engineering to enhance conceptual understanding.",
                            "Include exercises where students identify sides relative to different angles in right triangles to reinforce the concept of trigonometric ratios."
                          ]
                        }
                      },
                      "key_concepts_and_subconcepts": {
                        "concepts": {
                          "ai_recommendations": [
                            "Trigonometric Ratios: Focus on acute angles in right triangles as exemplified by the Qutub Minar scenario",
                            "Basic Trigonometric Ratios: Calculation of sine, cosine, and tangent for angles 0°, 30°, 45°, 60°, and 90°, including sides relative to the angle",
                            "Trigonometric Identities: Explanation and proof of fundamental identities starting with the primary sine and cosine relationship based on right-angled triangle properties"
                          ],
                          "additional_recommendations": [
                            "Historical Context: Origin of trigonometry and its application in astronomy and engineering",
                            "Identification of Sides: Exercises on identifying sides relative to different angles to reinforce trigonometric ratios concept",
                            "Triangles: Right triangles in practical surroundings such as those imagined at Qutub Minar",
                            "Trigonometric Ratios: Definition as ratios involving sides of a right triangle with respect to acute angles only",
                            "Trigonometric Ratios: Extension of ratios definition to angles 0° and 90°",
                            "Trigonometric Identities: Proof of identities true for all angle values including primary identity relating sine and cosine",
                            "Ratios: Concept of ratio as introduced in earlier classes applied to sides of right triangles"
                          ]
                        }
                      },
                      "prerequisite_knowledge": {
                        "prerequisite": {
                          "ai_recommendations": [
                            "Students should understand the properties of triangles, especially right-angled triangles, and be familiar with the concept of ratios from earlier grades.",
                            "Review knowledge of basic geometry such as types of angles and lengths of triangle sides, including identifying adjacent, opposite, and hypotenuse relative to a given angle.",
                            "Familiarity with measuring angles in degrees and basic arithmetic operations is essential for calculating trigonometric ratios."
                          ],
                          "additional_recommendations": [
                            "Integrate historical context highlighting trigonometry's origins and applications in astronomy and engineering.",
                            "Provide practice exercises focusing on identifying sides relative to various angles to solidify understanding of trigonometric ratios.",
                            "Use real-life examples, like the Qutub Minar scenario, to connect theory with practical applications."
                          ]
                        }
                      }
                    },
                    "learning_standards": {
                      "learning_outcomes": {
                        "outcomes": {
                          "ai_recommendations": [
                            "determines all trigonometric ratios with respect to a given acute angle (of a right triangle) and uses them in solving problems in daily life contexts like finding heights of different structures or distance from them."
                          ],
                          "additional_recommendations": []
                        }
                      },
                      "smart_learning_objectives": {
                        "objects": {
                          "ai_recommendations": [
                            "Students will identify all six trigonometric ratios (sine, cosine, tangent, cosecant, secant, and cotangent) for a given acute angle in a right triangle within 10 minutes. (Bloom's Taxonomy Level: Remembering)",
                            "Students will explain the significance of each trigonometric ratio in relation to sides of a right triangle within 5 minutes. (Bloom's Taxonomy Level: Understanding)",
                            "Students will apply trigonometric ratios to calculate unknown side lengths or angles in right triangles through problem-solving exercises related to daily life contexts such as measuring heights of structures within 15 minutes. (Bloom's Taxonomy Level: Applying)",
                            "Students will analyze real-life scenarios involving heights and distances and solve corresponding trigonometric problems accurately within the 30-minute session. (Bloom's Taxonomy Level: Analyzing)"
                          ],
                          "additional_recommendations": []
                        }
                      },
                      "competencies": {
                        "competency_list": [
                          {
                            "name": "CG-4",
                            "description":
                                "C-4.6: Understands the definitions of the basic trigonometric functions, their history and motivation (including the introduction of the sin and cos functions by Aryabhata using chords), and their utility across the sciences."
                          },
                          {
                            "name": "CG-4",
                            "description":
                                "C-4.1: Describes relationships including congruence of two-dimensional geometric shapes (such as lines, angles, triangles) to make and test conjectures and solve problems."
                          },
                          {
                            "name": "CG-4",
                            "description":
                                "C-4.2: Proves theorems using Euclid's axioms and postulates for triangles and quadrilaterals, and applies them to solve geometric problems."
                          },
                          {
                            "name": "CG-8",
                            "description":
                                "C-8.1: Models daily-life phenomena and uses representations such as graphs, tables, and equations to draw conclusions."
                          }
                        ]
                      }
                    },
                    "alignment": {
                      "materials_options": [
                        [
                          {
                            "ai_recommendations": [
                              {
                                "name":
                                    "Interactive Models of Triangles and Ratios",
                                "description":
                                    "Physical or digital models enabling hands-on exploration of triangle sides and angles"
                              },
                              {
                                "name": "Visual Charts of Trigonometric Ratios",
                                "description":
                                    "Charts illustrating sine, cosine, tangent values at key angles with side references"
                              },
                              {
                                "name": "Real-life Images and Scenarios",
                                "description":
                                    "Images such as Qutub Minar to relate trigonometric concepts to daily life"
                              }
                            ],
                            "additional_recommendations": [
                              {
                                "name": "Historical Timeline of Trigonometry",
                                "description":
                                    "Visual timeline outlining trigonometry's origin and evolution"
                              },
                              {
                                "name": "Side Identification Worksheets",
                                "description":
                                    "Printed materials to practice naming relative sides in right triangles"
                              }
                            ]
                          }
                        ]
                      ],
                      "instructional_strategies_options": [
                        [
                          {
                            "ai_recommendations": [
                              {
                                "name":
                                    "Guided Inquiry Using Real-Life Problems",
                                "description":
                                    "Promotes critical thinking by exploring trigonometric ratios through practical problems like height calculation"
                              },
                              {
                                "name":
                                    "Think-Pair-Share on Triangle Properties",
                                "description":
                                    "Encourages collaboration to deepen understanding of triangle side relationships"
                              },
                              {
                                "name": "Question-Driven Exploration",
                                "description":
                                    "Use strategic questioning to stimulate student reasoning about trigonometric identities"
                              }
                            ],
                            "additional_recommendations": [
                              {
                                "name": "Storytelling on Trigonometry History",
                                "description":
                                    "Connects content to students' cultural and historical knowledge"
                              },
                              {
                                "name": "Hands-On Group Activities",
                                "description":
                                    "Facilitates peer learning and engagement through cooperative tasks"
                              }
                            ]
                          }
                        ]
                      ],
                      "instructional_blocks": {
                        "introduction": {
                          "component_options": [
                            {
                              "name": "Engage with Qutub Minar Scenario",
                              "description":
                                  "Hooks students with a familiar landmark to spark interest"
                            },
                            {
                              "name": "Review Triangle Basics and Ratios",
                              "description":
                                  "Refreshes prerequisite knowledge of triangle types and side definitions"
                            }
                          ],
                          "formative_questions": [
                            "What sides do you identify in a right triangle relative to an angle?",
                            "How do real-life structures help us understand trigonometry?"
                          ],
                          "duration": 5
                        },
                        "development": {
                          "component_options": [
                            {
                              "name":
                                  "Demonstrate Calculations of Basic Ratios",
                              "description":
                                  "Model step-by-step computation of sine, cosine, tangent for key angles"
                            },
                            {
                              "name": "Explain Proof of Fundamental Identity",
                              "description":
                                  "Show proof linking sine and cosine beginning with right triangle properties"
                            },
                            {
                              "name": "Use GeoGebra or Digital Tools",
                              "description":
                                  "Interactive technology to visualize ratios and identities dynamically"
                            }
                          ],
                          "formative_questions": [
                            "Can you find sine and cosine of 45 degrees using a triangle?",
                            "Why does the identity sin²θ + cos²θ = 1 hold true?"
                          ],
                          "duration": 8
                        },
                        "guided_practice": {
                          "component_options": [
                            {
                              "name": "Calculate Ratios for Given Triangles",
                              "description":
                                  "Students compute ratios for specified angles with teacher support"
                            },
                            {
                              "name": "Identify Sides from Angles Worksheet",
                              "description":
                                  "Practice locating opposite, adjacent, hypotenuse sides in given figures"
                            },
                            {
                              "name":
                                  "Group Problem Solving with Real-Life Data",
                              "description":
                                  "Apply ratios to solve realistic height/distance problems collaboratively"
                            }
                          ],
                          "formative_questions": [
                            "How do you determine which side is opposite a given angle?",
                            "What is the tangent ratio of a 30-degree angle in the examples?"
                          ],
                          "duration": 6
                        },
                        "independent_practice": {
                          "component_options": [
                            {
                              "name":
                                  "Individual Exercises on Trigonometric Ratios",
                              "description":
                                  "Tasks focusing on calculation and application independently"
                            },
                            {
                              "name":
                                  "Create Real-Life Trigonometry Word Problems",
                              "description":
                                  "Students compose problems based on everyday scenarios involving heights/distances"
                            },
                            {
                              "name": "Peer Review of Problem Solutions",
                              "description":
                                  "Students exchange work and provide constructive feedback"
                            }
                          ],
                          "formative_questions": [
                            "Explain how you solved for the missing side using trigonometric ratios.",
                            "What challenges did you face applying trigonometry to your problem?"
                          ],
                          "duration": 5
                        },
                        "closure": {
                          "component_options": [
                            {
                              "name":
                                  "Summarize Key Concepts with Student Input",
                              "description":
                                  "Recap trigonometric ratios and identities collectively with student participation"
                            },
                            {
                              "name": "Reflect on Learning Connections",
                              "description":
                                  "Discuss how trigonometry relates to prior knowledge and real-world applications"
                            },
                            {
                              "name": "Preview Next Lesson Content",
                              "description":
                                  "Introduce upcoming topics to build continuity and interest"
                            }
                          ],
                          "formative_questions": [
                            "What is one new thing you learned today about triangle sides?",
                            "How can you apply trigonometric ratios outside the classroom?"
                          ],
                          "duration": 3
                        },
                        "summative_assessment": {
                          "component_options": [
                            {
                              "name":
                                  "Problem Set Assessing Ratio Calculations and Applications",
                              "description":
                                  "Evaluates accuracy in calculating and applying basic trig ratios"
                            },
                            {
                              "name":
                                  "Short Quiz on Identities and Definitions",
                              "description":
                                  "Tests understanding of sine, cosine, tangent definitions and primary identities"
                            },
                            {
                              "name": "Real-Life Scenario Analysis",
                              "description":
                                  "Students solve height/distance problems based on a given real-world context"
                            },
                            {
                              "name": "Oral Presentation of Solution Approach",
                              "description":
                                  "Assesses ability to explain reasoning verbally with clarity and precision"
                            },
                            {
                              "name":
                                  "Group Project: Measuring Heights with Trigonometric Tools",
                              "description":
                                  "Evaluation of collaborative application and reporting skills"
                            }
                          ],
                          "formative_questions": [],
                          "duration": 3
                        }
                      }
                    },
                    "content_generation": {
                      "introduction_block": {
                        "components": [
                          {
                            "component_name":
                                "Engage with Qutub Minar Scenario",
                            "duration_minutes": 5,
                            "materials_used": [
                              "Image or drawing of Qutub Minar, whiteboard or chart paper, markers"
                            ],
                            "implementation_script":
                                "Begin the session by showing an image or drawing of the Qutub Minar and ask students to imagine standing at a certain distance from it. Ask them to think about how one might measure its height without physically climbing it. Use this context to introduce the idea of right triangles formed by the line from the observer to the top of the Minar, the ground, and the vertical height of the Minar.\n\nPrompt students to recall what they know about triangles, especially right triangles, and how angles and side lengths relate. Connect this real-world example to the abstraction of trigonometric ratios, positioning trigonometry as a practical tool for solving such measurement problems.",
                            "formative_questions": [
                              "Can anyone tell me what kind of triangle might be formed if we draw a line from our position to the top of the Qutub Minar and then down to its base?",
                              "What do you think we need to know to find the height of the Qutub Minar using this triangle?"
                            ],
                            "expected_responses": [
                              "A right triangle is formed, with the height as one side, the ground as the base, and the line of sight as the hypotenuse.",
                              "We need to know the length of one side and some angles or other side lengths to calculate the height."
                            ],
                            "teacher_notes":
                                "Use this scenario to spark curiosity and contextualize trigonometry. Emphasize the practical application to engage students. Circulate during discussion to assess student background and steer conversations towards key concepts of right triangles and measurement needs."
                          },
                          {
                            "component_name":
                                "Review Triangle Basics and Ratios",
                            "duration_minutes": 5,
                            "materials_used": [
                              "Diagrams of right triangles, ruler, whiteboard, markers"
                            ],
                            "implementation_script":
                                "Review key concepts of triangles, focusing on right triangles, their properties, and the terms 'hypotenuse,' 'opposite,' and 'adjacent' relative to a chosen angle. Engage students in identifying these sides in sample diagrams.\n\nRecall the concept of ratio from previous learning and explain how ratios can relate the sides of a triangle. Lead a short interactive activity where students identify side lengths and form ratios, setting the stage for trigonometric ratios.",
                            "formative_questions": [
                              "In this triangle, if angle A is our reference, which side is opposite to angle A? Which side is adjacent?",
                              "If the length of the hypotenuse is 5 units and the side opposite angle A is 3 units, what is the ratio of opposite to hypotenuse?"
                            ],
                            "expected_responses": [
                              "The side directly across from angle A is opposite; the side next to angle A (but not hypotenuse) is adjacent.",
                              "The ratio of opposite to hypotenuse is 3:5."
                            ],
                            "teacher_notes":
                                "This activity strengthens prerequisite knowledge crucial for understanding trigonometric ratios. Use formative questioning to diagnose misconceptions about side identification. Encourage peer discussion and justify answers. Adapt pacing based on student responses and clarify vocabulary as needed."
                          }
                        ]
                      },
                      "development_block": {
                        "components": [
                          {
                            "component_name":
                                "Introduction to Trigonometric Ratios with Qutub Minar Context",
                            "duration_minutes": 8,
                            "materials_used": [
                              "Diagram of right triangle with labeled sides and angles",
                              "Image or brief story about Qutub Minar",
                              "Historical timeline slide on trigonometry",
                              "Worksheet/handout for side identification exercises"
                            ],
                            "implementation_script":
                                "1. Begin by activating prior knowledge: Recall properties of right triangles and ratios from previous lessons.\n2. Introduce the concept of trigonometric ratios focusing on acute angles in a right triangle using the Qutub Minar scenario. Explain how right triangles can be imagined when measuring heights such as that of Qutub Minar.\n3. Display a clear diagram of a right triangle with angle marked (acute angle).\n4. Define sine, cosine, and tangent as ratios of sides relative to the acute angle: sine = opposite/hypotenuse, cosine = adjacent/hypotenuse, tangent = opposite/adjacent.\n5. Use the diagram to model identifying opposite, adjacent sides and hypotenuse relative to given acute angle.\n6. Incorporate historical context briefly: Explain Aryabhata's contribution using sine and cosine, early use in astronomy and engineering.\n7. Use guided questioning to engage students: \"Can someone identify the hypotenuse in this triangle?\" \"What side is opposite angle A?\"\n8. Students work on simple exercises identifying sides relative to given angles in small pairs.\n9. Circulate and provide feedback, clarify misconceptions.",
                            "formative_questions": [
                              "Can you point out the hypotenuse in this triangle?",
                              "Which side is adjacent to angle A?",
                              "What is the definition of sine relative to an acute angle?"
                            ],
                            "expected_responses": [
                              "The longest side opposite the right angle is the hypotenuse.",
                              "The side next to angle A, but not the hypotenuse, is adjacent.",
                              "Sine is the ratio of the length of the side opposite the angle to the hypotenuse."
                            ],
                            "teacher_notes":
                                "Use clear, observable language when explaining ratios. Frequently check for understanding by asking students to point to sides and define ratios themselves. Emphasize correct identification of sides relative to the chosen angle to build foundational understanding. Use the Qutub Minar example to connect math to real-life contexts and foster engagement."
                          }
                        ]
                      },
                      "guided_practice_block": {
                        "components": [
                          {
                            "component_name":
                                "Calculate Trigonometric Ratios for Given Right Triangles",
                            "duration_minutes": 6,
                            "materials_used": [
                              "Worksheet with right triangle diagrams and side lengths",
                              "Chart or board with labeled triangle diagram"
                            ],
                            "implementation_script":
                                "Step 1: Begin the activity by reviewing the concepts of opposite, adjacent, and hypotenuse sides relative to the given acute angle in a right triangle. Use a clear diagram on the board or chart showing a right triangle, labeling sides based on a chosen angle.\n\nStep 2: Distribute worksheets containing illustrations of right triangles with specified side lengths and marked acute angles (e.g., 30°, 45°, 60°).\n\nStep 3: Guide students to calculate sine, cosine, and tangent ratios for the given angles using the side lengths provided. Model one example on the board, explaining each step clearly.\n\nStep 4: Circulate around the classroom, asking clarifying questions such as \"Which side is opposite to this angle?\", \"What is the hypotenuse length?\", and \"How do you compute the sine ratio?\" to check understanding and prompt reasoning.\n\nStep 5: Pause at the midpoint and conduct a formative checkpoint by asking a few students to explain their process aloud and identifying any misconceptions.\n\nStep 6: Adjust instruction as needed to address any misunderstandings, providing additional examples or peer support.\n\nStep 7: Conclude the activity by summarizing key points and inviting students to self-assess their confidence with calculating these ratios.",
                            "formative_questions": [
                              "Can you identify the side opposite to the given angle?",
                              "How do you determine which side is adjacent to the angle?",
                              "What is the formula to calculate sine (or cosine, tangent) based on the sides?",
                              "Can you explain why the hypotenuse is always the longest side?",
                              "How do these ratios change when the angle changes?"
                            ],
                            "expected_responses": [
                              "The side opposite is the one across from the given angle.",
                              "The adjacent side is the side that forms the angle along with the hypotenuse but is not the hypotenuse.",
                              "Sine is opposite over hypotenuse, cosine is adjacent over hypotenuse, tangent is opposite over adjacent.",
                              "The hypotenuse is the longest side by triangle property because it is opposite the right angle.",
                              "Ratios vary because the lengths of opposite and adjacent sides change with the angle."
                            ],
                            "teacher_notes":
                                "Ensure to use clear and accurate diagrams for visual support (3a). Ask strategic questions that prompt students to articulate their reasoning (3b). Circulate during student work to maintain engagement and provide timely feedback (3c, 3d, 3e). Be ready to provide additional scaffolding for students struggling with side identification or ratio computation. Use student explanations at checkpoints to inform instructional adjustments."
                          },
                          {
                            "component_name":
                                "Identify Sides Relative to Different Acute Angles Worksheet",
                            "duration_minutes": 6,
                            "materials_used": [
                              "Worksheet with right triangle diagrams showing different acute angles",
                              "Chart or projector displaying triangle labeling examples"
                            ],
                            "implementation_script":
                                "Step 1: Display a diagram of a right triangle labeled with vertices (like ABC), showing different acute angles.\n\nStep 2: Provide a worksheet with various right triangle diagrams, each highlighting a different acute angle.\n\nStep 3: Ask students to label the opposite, adjacent, and hypotenuse sides with respect to the indicated angle on each diagram.\n\nStep 4: Pair students for discussion, encouraging them to explain their labels to each other using appropriate vocabulary.\n\nStep 5: Teacher circulates, asking open-ended guiding questions such as \"Why do you think this side is adjacent?\", \"Can you justify the hypotenuse side?\" to reinforce conceptual understanding.\n\nStep 6: Conduct a formative checkpoint by selecting volunteers to share their reasoning with the whole class.\n\nStep 7: Address any misconceptions, clarify definitions, and reinforce the real-life significance using the previously introduced Qutub Minar example.\n\nStep 8: Summarize key points and encourage students to self-assess their understanding.",
                            "formative_questions": [
                              "How do you decide which side is opposite the given angle?",
                              "What makes a side the adjacent side?",
                              "Why is the hypotenuse always the same side regardless of the angle?",
                              "Can the opposite side change when the angle considered changes?",
                              "How would you explain these terms to a classmate?"
                            ],
                            "expected_responses": [
                              "The opposite side is the one across from the angle.",
                              "The adjacent side touches the angle and is not the hypotenuse.",
                              "The hypotenuse is always the side opposite the right angle, so it never changes.",
                              "Yes, opposite side changes because it's defined relative to the angle chosen.",
                              "By pointing out sides relative to the angle and relating them to the triangle's structure."
                            ],
                            "teacher_notes":
                                "Use visual aids to ensure clarity and support diverse learners (3a). Facilitate peer discussion to promote strategic questioning and collaborative learning (3b, 3c). Monitor student conversations for misconceptions and provide immediate feedback (3d). Adjust pairing or support based on formative checkpoint insights (3e). Reinforce connections to real life examples to enhance relevance and engagement."
                          },
                          {
                            "component_name":
                                "Group Problem Solving with Real-Life Height and Distance Scenarios",
                            "duration_minutes": 6,
                            "materials_used": [
                              "Group problem worksheet with real-life trigonometry scenarios",
                              "Calculator",
                              "Chart with trigonometric ratio formulas"
                            ],
                            "implementation_script":
                                "Step 1: Present a real-life context problem such as measuring the height of the Qutub Minar using trigonometric ratios.\n\nStep 2: Organize students into small groups and provide each group with a set of data including angle of elevation, distance from object, and any needed measurements.\n\nStep 3: Each group identifies the right triangle formed in the scenario and decides which trigonometric ratio to apply for solving for the unknown height or distance.\n\nStep 4: Groups collaboratively solve the problem, calculating the required side lengths and justifying their methods.\n\nStep 5: Teacher circulates, prompting reflection with questions like \"Which trigonometric ratio did you choose and why?\", \"How accurate do you think your calculation is based on the data provided?\"\n\nStep 6: Conduct a formative checkpoint by asking groups to share their solution approach and reasoning with the class.\n\nStep 7: Provide corrective feedback, highlighting common errors or alternative solution paths.\n\nStep 8: Wrap up by connecting the activity to real-world applications and encouraging self-assessment of problem-solving strategies.",
                            "formative_questions": [
                              "What angle and sides does this problem give you?",
                              "Which trigonometric ratio fits this situation best?",
                              "How do you calculate the side length once you choose the ratio?",
                              "Does your answer seem reasonable given the scenario?",
                              "What assumptions did you make in your calculation?"
                            ],
                            "expected_responses": [
                              "The problem gives an angle of elevation and distance from the object.",
                              "Tangent ratio can be used when opposite and adjacent sides relate.",
                              "Multiply or divide sides as per sin, cos, or tan definition.",
                              "Yes, my answer is reasonable compared to the known height or distance.",
                              "Assumed the ground is flat and the angle measurement is correct."
                            ],
                            "teacher_notes":
                                "Select real-life problems that connect to students' experiences to enhance engagement (3c). Use targeted questioning during group work to deepen conceptual understanding and application (3b, 3d). Circulate actively to support groups and manage pacing (3e). Use group presentations as formative assessments to inform subsequent instruction. Highlight interdisciplinary connections and real-world use cases to build transfer and motivation."
                          }
                        ]
                      },
                      "independent_practice_block": {
                        "components": [
                          {
                            "component_name":
                                "Individual Exercises on Trigonometric Ratios",
                            "duration_minutes": 5,
                            "materials_used": [
                              "Worksheet with trigonometric ratio problems",
                              "Scientific calculator or trigonometric tables",
                              "Notebook and pencil"
                            ],
                            "implementation_script":
                                "Students will independently solve a set of problems that involve calculating the sine, cosine, and tangent ratios for specified angles (0°, 30°, 45°, 60°, 90°) in right triangles. They will identify the opposite, adjacent, and hypotenuse sides relative to the acute angle given in each problem and then compute these ratios correctly. Problems will include real-life applications, such as determining the height of a structure using a given angle of elevation, linking directly to daily life contexts like the Qutub Minar example.",
                            "formative_questions": [
                              "Which side is opposite the given angle in this right triangle?",
                              "What is the sine of the given angle based on your calculations?"
                            ],
                            "expected_responses": [
                              "The side opposite the angle is the side opposite to the angle marked in the triangle diagram.",
                              "The sine value is the ratio of the length of the opposite side to the hypotenuse, for example, sin 30° = 1/2."
                            ],
                            "teacher_notes":
                                "Observe if students correctly identify corresponding sides relative to the angle before calculating ratios. Ask clarifying questions such as 'Can you explain why this side is opposite to the angle?' or 'How did you determine this ratio?' Circulate to check for misconceptions and provide immediate formative feedback to support understanding."
                          }
                        ]
                      },
                      "closure_block": {
                        "components": [
                          {
                            "component_name":
                                "Summarize Key Concepts with Student Input",
                            "duration_minutes": 3,
                            "materials_used": [
                              "Visual aids of right triangles",
                              "Checklist on board or digital display"
                            ],
                            "implementation_script":
                                "Gather students for a collective discussion to recap the definitions and calculations of trigonometric ratios (sine, cosine, tangent) especially for acute angles in right triangles. Use a visual of a right triangle similar to the Qutub Minar scenario as a reference. Invite students to contribute by stating what they have learned about identifying the opposite, adjacent, and hypotenuse sides relative to a given angle. Pose clarifying questions such as: 'Can someone explain why the sine ratio relates to the opposite side over hypotenuse?' Use a checklist displayed on the board to confirm coverage of key points: definition of trigonometric ratios, calculation for specific angles, and understanding of fundamental identities.",
                            "formative_questions": [
                              "Can you identify the opposite, adjacent, and hypotenuse sides relative to angle A in a right triangle?",
                              "How do we calculate sine, cosine, and tangent ratios for an acute angle?",
                              "Why is the fundamental identity sin²θ + cos²θ = 1 important?"
                            ],
                            "expected_responses": [
                              "Students correctly identify sides relative to an angle",
                              "Students explain ratio calculations clearly",
                              "Students recognize and state the fundamental trigonometric identity"
                            ],
                            "teacher_notes":
                                "During this activity, circulate among students to listen for misconceptions and prompt elaboration. Use students' contributions to correct misunderstandings. Model clear mathematical language and encourage students to express concepts in their own words."
                          },
                          {
                            "component_name": "Reflect on Learning Connections",
                            "duration_minutes": 3,
                            "materials_used": [
                              "Reflection prompt cards or slides"
                            ],
                            "implementation_script":
                                "Facilitate a guided reflection where students connect trigonometric concepts learned today to prior knowledge (geometry, ratios) and real-world examples like measuring the height of Qutub Minar. Ask open-ended questions such as: 'How can the trigonometric ratios help us solve real-life problems?' and 'In what ways does understanding triangle properties support learning trigonometry?' Stimulate discussion emphasizing the origins and applications of trigonometry in fields like astronomy and engineering. Encourage students to self-assess their understanding and articulate any remaining questions.",
                            "formative_questions": [
                              "What prior knowledge helped you understand trigonometric ratios better?",
                              "Can you give a real-life example where trigonometry is useful?",
                              "What questions do you still have about today’s lesson?"
                            ],
                            "expected_responses": [
                              "Connections made between ratios and trigonometry",
                              "Examples of real-world applications cited",
                              "Students express areas needing clarification"
                            ],
                            "teacher_notes":
                                "Listen actively and validate all contributions to support a positive classroom climate. Adjust next lessons to address common questions or gaps identified here. Encourage peer support to deepen understanding."
                          },
                          {
                            "component_name": "Preview Next Lesson Content",
                            "duration_minutes": 3,
                            "materials_used": [
                              "Summary slide or outline of future topics"
                            ],
                            "implementation_script":
                                "Provide a brief overview of upcoming topics such as extending trigonometric ratios beyond acute angles, exploring cosecant, secant, and cotangent ratios, and proving additional trigonometric identities. Use engaging dialogue like, 'Next, we will explore how these ratios help us solve even more complex problems and see their broader applications.' Connect this preview to today’s learning and articulate how mastering today’s content will support new learning. Invite students to think about potential questions or predictions about future lessons.",
                            "formative_questions": [
                              "What interests you most about learning more trigonometric ratios?",
                              "How do you think knowing more about these identities will help you?",
                              "What do you expect to learn in the next lesson based on today’s discussion?"
                            ],
                            "expected_responses": [
                              "Students express curiosity or anticipation",
                              "Students make connections to today’s concepts",
                              "Students share predictions or questions about future content"
                            ],
                            "teacher_notes":
                                "Use student responses to tailor the upcoming lesson hooks and to build excitement. Reinforce the learning continuum and relate new content back to current mastery, promoting student ownership of learning."
                          }
                        ]
                      },
                      "assessment_block": {
                        "components": [
                          {
                            "component_name":
                                "Multiple Choice Questions on Trigonometric Ratios and Definitions",
                            "duration_minutes": 3,
                            "materials_used": ["MCQ worksheet or digital quiz"],
                            "implementation_script":
                                "Provide students with 5 multiple choice questions focusing on definitions of sine, cosine, tangent for acute angles, identifying opposite, adjacent sides and hypotenuse, and basic trigonometric ratio values for special angles (0°, 30°, 45°, 60°, 90°). Use real-life contextual examples such as the Qutub Minar to make questions relevant. Sample questions include: - Identifying the hypotenuse in a right triangle given an angle. - Finding sine value of 30°. - Understanding which side is adjacent to the angle in question. - Conceptual definition of tangent ratio. - Extension of trigonometric ratios to 0° and 90°. Circulate in class, clarify misconceptions, and encourage students to explain reasoning before answering.",
                            "formative_questions": [
                              "What side is opposite to the angle in a right triangle?",
                              "What is the sine of 45°?",
                              "How do we define tangent of an angle?",
                              "Which side is hypotenuse and why?",
                              "Can trigonometric ratios be defined for 0° and 90° angles?"
                            ],
                            "expected_responses": [
                              "Opposite side to the given angle.",
                              "Sine of 45° = √2/2.",
                              "Tangent is ratio of opposite side to adjacent side.",
                              "Hypotenuse is the longest side opposite to right angle.",
                              "Yes, they can be defined with limits or appropriate extension."
                            ],
                            "teacher_notes":
                                "Ensure students understand naming of sides relative to angle and values of basic ratios for special angles. Use examples from real-life context like Qutub Minar to make concepts relatable. Prompt students to explain choices to check understanding and address misconceptions immediately."
                          },
                          {
                            "component_name":
                                "Worksheet Tasks on Calculating Trigonometric Ratios for Given Angles",
                            "duration_minutes": 3,
                            "materials_used": [
                              "Printed worksheets",
                              "Calculator"
                            ],
                            "implementation_script":
                                "Distribute a worksheet containing 3-5 problems where students calculate sine, cosine, and tangent of angles 30°, 45°, 60°, and also for 0° and 90°. Problems should ask for sides relative to the angle and use triangles with given side lengths or ratios. Include applied problems such as calculating the height of an imagined structure based on angle of elevation and distance, reflecting daily life context. Students work individually or in pairs, apply trigonometric ratios, and fill in answers with clear calculation steps. Teacher circulates to check for errors and provide support.",
                            "formative_questions": [
                              "How do you identify the opposite and adjacent sides for this angle?",
                              "Which formula will you use to find sine of 60°?",
                              "What does sine of 0° equal and why?",
                              "How can we apply these ratios to calculate height of a building?",
                              "What is the relationship between sine and cosine for complementary angles?"
                            ],
                            "expected_responses": [
                              "Opposite side is the one across from the angle, adjacent is next to it except hypotenuse.",
                              "Sine(60°) = opposite/hypotenuse = √3/2.",
                              "Sine of 0° is 0 because opposite side length tends to 0.",
                              "Using tangent or sine ratio with given distance and angle to find height.",
                              "Sine of angle = cosine of complementary angle."
                            ],
                            "teacher_notes":
                                "Emphasize correct identification of sides relative to the angle before calculating ratios. Encourage showing all steps to foster clear understanding. Use real-life inspired problems for better engagement and transfer. Circulate and provide hints or scaffolding as needed."
                          },
                          {
                            "component_name":
                                "Short Answer Questions on Trigonometric Identities and Conceptual Understanding",
                            "duration_minutes": 3,
                            "materials_used": [
                              "Short answer handouts or notebooks"
                            ],
                            "implementation_script":
                                "Students answer 3-4 short questions focused on explaining and proving fundamental trigonometric identities such as sin²θ + cos²θ = 1, and conceptual meanings of trigonometric functions. Questions include proving identities using right triangle properties, explaining why identities hold for all angle values, and interpreting sine and cosine in unit circle context briefly. Students write explanations showing reasoning. Teacher reviews answers for conceptual clarity and correctness, provides instant feedback or clarifications.",
                            "formative_questions": [
                              "How can we prove sin²θ + cos²θ = 1 using a right triangle?",
                              "Why is this identity true for all angles?",
                              "Explain in your own words what sine and cosine functions represent.",
                              "How do these identities help in solving trigonometric problems?",
                              "What is one real-life application where these identities are useful?"
                            ],
                            "expected_responses": [
                              "Using Pythagoras theorem on triangle sides and definition of sine and cosine as ratios.",
                              "Because they derive from Pythagoras theorem applied to unit circle or triangle.",
                              "Sine represents ratio of opposite side to hypotenuse; cosine the adjacent to hypotenuse.",
                              "They simplify calculations and confirm relationships between ratios.",
                              "Calculation of heights, distances or engineering measurements."
                            ],
                            "teacher_notes":
                                "Aim to build deeper understanding beyond procedural knowledge. Encourage thinking about how identities connect to geometric properties and real applications. Address misconceptions promptly and encourage explanation in student’s own words."
                          }
                        ]
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
