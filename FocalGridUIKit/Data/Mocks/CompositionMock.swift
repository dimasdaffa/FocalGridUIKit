//
//  CompositionMock.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import Foundation

extension Composition {
    static let mockCompositions: [Composition] = [
        Composition(
            type: .ruleOfThirds,
            description: "Ever wonder why some photos instantly grab your attention while others feel completely flat? The secret isn't a better camera, it's how you position your subject.\n\nThe Rule of Thirds is a powerful visual blueprint that divides your frame into a clean 3x3 grid. By placing your subject off-center, you create a natural sense of balance, energy, and tension that immediately pulls the viewer's eyes into the story.",
            keyIdeasCount: 4,
            durationText: "1-2 min",
            mechanics: [
                GridMechanic(
                    id: "rot_mech_1",
                    title: "The 3x3 Grid Matrix",
                    readingTime: "1 min",
                    headline: "Stop centering your subject.\nYour brain craves off-center balance.",
                    bodyContent: "When you look through your viewfinder, imagine **splitting** the image into **three equal** horizontal and vertical sections.\n\n• **The Rookie Mistake:** Placing your subject dead-center, which suffocates the composition and feels static.\n\n• **The Pro Fix:** Leaving empty space on the opposite two-thirds of the screen to give your subject room to **breathe or move**.",
                    imageAsset: "mock_rot_matrix"
                ),
                GridMechanic(
                    id: "rot_mech_2",
                    title: "How to Use It",
                    readingTime: "1 min",
                    headline: "The magic happens where the lines crash into each other.",
                    bodyContent: "Your viewer's eyes are already waiting there. The four intersections where your grid lines cross are the ultimate target zones. Human physics dictates that **The Eye Level** naturally darts to these **intersection points** before looking anywhere else in the frame.\n\nInstead of guessing, lock your **Golden Target**—be it a subject's sharp looking eye, a faraway lighthouse, or the main focal point of an action scene—directly onto one of these four crossing marks to instantly anchor the narrative.",
                    imageAsset: nil,
                    layoutStyle: .textCentered
                ),
                GridMechanic(
                    id: "rot_mech_3",
                    title: "When to Deploy The Rule",
                    readingTime: "1 min",
                    headline: "Different scenarios demand different grids. Choose your rules carefully before clicking the shutter.",
                    bodyContent: "**LANDSCAPES** — Lock the horizon line precisely onto the bottom third to amplify a dramatic sky, or shift it to the top third to expose foreground textures.\n\n**ACTION & MOTION** — If a subject is moving from left to right, frame them strictly on the left third line. Always give your subject *\"space to run into.\"*\n\n**PORTRAITS** — Align the spine or weight of the subject's body with a clean vertical line to create a powerful, *artistic asymmetry*.",
                    imageAsset: nil
                )
            ],
            breakdown: PhotographicBreakdown(
                headline: "Why does this shot work? Let's dissect the composition layer by layer.",
                imageAsset: "mock_mx_bike",
                photographer: "dimas daffa",
                layers: [
                    CompositionLayer(title: "The Airborne Rider", description: "sits precisely onto the upper-right intersection point. Notice why the airborne momentum feels incredibly dramatic and cinematic."),
                    CompositionLayer(title: "The Launch Gate", description: "aligns with the left vertical line, tracking where the action began."),
                    CompositionLayer(title: "The Massive Negative Space", description: "occupying the center and lower-right quadrants provides a vital *\"space to fly into,\"* giving the viewer's brain room to feel the speed and imagine the landing path.")
                ]
            )
        ),
        Composition(
            type: .goldenRatio,
            description: "Nature doesn't build in straight squares. Your composition shouldn't either.\n\nWhen you look through your viewfinder, imagine a logarithmic curve—a flowing energy line that draws viewers deep into the image. Unlike the grid-like Rule of Thirds, the Golden Spiral follows nature's own mathematical rhythm.",
            keyIdeasCount: 4,
            durationText: "1-2 min",
            mechanics: [
                GridMechanic(
                    id: "gr_mech_1",
                    title: "The Phi Spiral Grid",
                    readingTime: "1 min",
                    headline: "Nature doesn't build in straight squares.\nYour composition shouldn't either.",
                    bodyContent: "When you look through your viewfinder, imagine a logarithmic curve—a flowing energy line that draws viewers deep into the image.\n\n• **The Rookie Mistake:** Your composition doesn't follow the same grid as the Rule of Thirds. Instead, it follows the exact ratio of the **Golden Spiral**.\n\n• **The Core Rule:** Place your composition's subject at the end of the **Golden Spiral**, where all the energy funnels toward—so your viewer's eye naturally spirals inward.\n\nBy alignment of your **Visual Anchor** along the spiral's tightening curve, you choose an organic visual flow—your subject's eye to island to anchor—falling along the curve.",
                    imageAsset: "mock_gr_spiral"
                ),
                GridMechanic(
                    id: "gr_mech_2",
                    title: "How to Use It",
                    readingTime: "1 min",
                    headline: "The magic spine sits right inside the eye of the spiral.",
                    bodyContent: "The point where the spiral collapses tightest is called the **Focus Point**. Unlike the four intersections of the Rule of Thirds, you have a single, more nuanced target zone.\n\nYour anchor subject—a person's intense gaze, a far away clock tower—should fall wherever the spiral curls into its smallest curve. Let the background action radiate along the outer curve, fading directly to your primary human subject.\n\nPull it with **internal framing.** The loose end of the spiral creates a natural frame—use it to fold layers of depth, hierarchy, and flow into a viewer's eye in a clockwise or counter-clockwise sweep.",
                    imageAsset: nil,
                    layoutStyle: .textCentered
                ),
                GridMechanic(
                    id: "gr_mech_3",
                    title: "When to Deploy The Rule",
                    readingTime: "1 min",
                    headline: "Complex scenes demand organic balance. Here's when to unleash the grid for the spiral.",
                    bodyContent: "**ARCHITECTURE & CURVES** — Perfect. By snaking a staircase, archway, corridors, or row-angle brick walls. Let the structural lines mirror the swirling motion.\n\n**STREET & STORYTELLING** — Lock a subject into a daily environment that would echo an editorial style—something far more nuanced than standard. Let the leading curves construct a natural storyline along the outer curve, fading directly to your primary human subject.\n\n**CLOSE-UP PORTRAITS** — Align the spiral's curl onto face's defining trait: the subject's dominant eye, letting their hair or shoulders follow the swooping outer curve.",
                    imageAsset: nil
                )
            ],
            breakdown: PhotographicBreakdown(
                headline: "Why does this shot work? Let's dissect the composition layer by layer.",
                imageAsset: "mock_gr_breakdown",
                photographer: "dimas daffa",
                layers: [
                    CompositionLayer(title: "The Golden Ratio", description: "looks precisely at the spiral's tightest point, pulling the viewer's eye in a rhythmic sweep."),
                    CompositionLayer(title: "The Outer Spiral", description: "the loose end that frames the viewer's eye spiraling outward, creating a rhythmic visual flow."),
                    CompositionLayer(title: "The Charming Posture", description: "in terms of pose and visual sweep creates a rhythmic harmony in the composition.")
                ]
            )
        ),
        Composition(
            type: .diagonalLines,
            description: "Static frames create boring stories. Slicing the canvas creates instant drama.\n\nWhen you look through your viewfinder, look for dominant lines or creating diagonal that cuts from one corner toward the opposite. Dynamic movement requires dynamic boundaries. Slash the canvas when the narrative's speed and chaos demand it.",
            keyIdeasCount: 4,
            durationText: "1-2 min",
            mechanics: [
                GridMechanic(
                    id: "dl_mech_1",
                    title: "The Kinetic Slopes",
                    readingTime: "1 min",
                    headline: "Static frames create boring stories.\nSlicing the canvas creates instant drama.",
                    bodyContent: "When you look through your viewfinder, look for dominant lines or creating a target that cuts from one corner toward the opposite.\n\n• **The Kinetic Force:** Diagonal lines break the sense of speed, tension, or deep perspective.\n\n• **The Core Rule:** Place your composition so that objects, textures, or spatial patterns—roads, rivers, or the architecture itself—follow a crisp 30-60 degree diagonal line from one edge to another.\n\nBy placing **Diagonal Lines** into a composition, you force the viewer's eye into an immediate and inescapable sense of visual chaos.",
                    imageAsset: "mock_dl_slopes"
                ),
                GridMechanic(
                    id: "dl_mech_2",
                    title: "How to Use It",
                    readingTime: "1 min",
                    headline: "Control the pacing by controlling the repetition.",
                    bodyContent: "It doesn't just push your eye. It's **leading it.**\n\nA single bold diagonal creates a line of visual force, guiding the viewer across one clear path from one corner of your frame and guides the viewer directly into the action.\n\nPull it with **internal framing.** The close end of the Visual Check creates a natural anchor for the viewer's eye to land before following the force.",
                    imageAsset: nil,
                    layoutStyle: .textCentered
                ),
                GridMechanic(
                    id: "dl_mech_3",
                    title: "When to Deploy The Rule",
                    readingTime: "1 min",
                    headline: "Dynamic moments require dynamic boundaries. Slash the canvas when the narrative's speed and chaos demand it.",
                    bodyContent: "**SPORTS & RACING** — Ideal for starting gates, running tracks, or cars in motion. Align the direction of acceleration below the action even further.\n\n**URBAN PATTERNS** — Look for repeating rows of windows, architecture, and staircases. A staircase is a built-in spiral. Turn static concrete into a rhythmic perspective.\n\n**REPEATING CROWD** — Frame a mix of people, soldiers, or objects standing in sequence. Shift position to capture them all on single clear **Diagonal** line.",
                    imageAsset: nil
                )
            ],
            breakdown: PhotographicBreakdown(
                headline: "Why does this shot work? Let's dissect the composition layer by layer.",
                imageAsset: "mock_dl_breakdown",
                photographer: "dimas daffa",
                layers: [
                    CompositionLayer(title: "The Kinetic Slopes", description: "carve the frame with a sharp, geometric diagonal that drives the viewer's eye from one corner to another."),
                    CompositionLayer(title: "The Repeating Pattern", description: "creates a rhythmic pulse across the frame that amplifies the sense of speed and momentum."),
                    CompositionLayer(title: "The Dark Foreground Silhouette", description: "masks the shadows and defines edges where all lines converge, pulling the viewer deeper into the frame.")
                ]
            )
        ),
        Composition(
            type: .leadingLines,
            description: "Every line in your frame is a hidden highway for the viewer's subconscious.\n\nWhen you look through your viewfinder, identify roads, pathways, railings, or any lines that stretch from the edges toward the subject. Urban geometry demands structured pathways. Slash the frame to build an inescapable perspective.",
            keyIdeasCount: 4,
            durationText: "1-2 min",
            mechanics: [
                GridMechanic(
                    id: "ll_mech_1",
                    title: "The Vanishing Point",
                    readingTime: "1 min",
                    headline: "Every line in your frame is a hidden highway for the viewer's subconscious.",
                    bodyContent: "When you look through your viewfinder, identify roads, pathways, railings, or any lines that stretch from the edges toward the subject.\n\n• **The Visual Anchor:** Symmetrical architectural lines where it appears to disappear into the distance, dragging the eye toward an invisible vanishing point.\n\n• **The Destination:** Lines place your primary subject at or near the point of convergence—the place where a converging line finally collides.",
                    imageAsset: "mock_ll_vanishing"
                ),
                GridMechanic(
                    id: "ll_mech_2",
                    title: "How to Use It",
                    readingTime: "1 min",
                    headline: "The line doesn't always have to be perfectly straight.",
                    bodyContent: "While street rails in a two-lane, straight road, or a path creates an obvious visual funnel, not all lines that serve as guides are that direct.\n\nThe use of only Staircase that have ever been perfectly straight is incredibly rare.\n\nInstead, **curving lines**—a winding river, the curve of a trail, rocky footpath—carry the same leading power. Use an implicit Leading Line—think the direction of a person's gaze, then let the blend of curves create the final depth.",
                    imageAsset: nil,
                    layoutStyle: .textCentered
                ),
                GridMechanic(
                    id: "ll_mech_3",
                    title: "When to Deploy The Rule",
                    readingTime: "1 min",
                    headline: "Urban geometry demands structured pathways. Slash the frame to build an inescapable perspective.",
                    bodyContent: "**STREETS & ALLEYS** — Long corridors, train tracks, or narrow city blocks. Let the natural architecture build the depth on your behalf.\n\n**NATURAL PATHS** — Look for rivers, rows of shops, or distant trails. Guide the user through nature's visual trail.\n\n**VANITY SHOTS** — Combine shadows with a carefully constructed leading line. Use an implied line—think the direction of a person's gaze, then let the blend of curves create the final depth.",
                    imageAsset: nil
                )
            ],
            breakdown: PhotographicBreakdown(
                headline: "Why does this shot work? Let's dissect the composition layer by layer.",
                imageAsset: "mock_ll_breakdown",
                photographer: "dimas daffa",
                layers: [
                    CompositionLayer(title: "The Vanishing Point", description: "sits on the far right side, creating an inescapable pull into the distance."),
                    CompositionLayer(title: "The Railings And Archway", description: "on the right side converge directly toward the vanishing point, creating an irresistible visual corridor."),
                    CompositionLayer(title: "The Linear Floor Grid", description: "and parallel lines converging to the far distance reinforced by the architecture."),
                    CompositionLayer(title: "The Dark Foreground Silhouette", description: "masks the shadows and defines edges where all lines converge, pulling the viewer deeper into the frame.")
                ]
            )
        ),
        Composition(
            type: .symmetry,
            description: "Ever wonder why a perfectly centered subject can look incredibly powerful, while others just look like an amateur mistake? The secret lies in absolute intentionality—it’s about locking a flawless geometric order into your canvas.\n\nThe Symmetrical Balance framework trades the dynamic tension of off-center rules for total visual equilibrium. By splitting your frame directly down the dead center, you create an unshakeable sense of **stability, gravity, and formal dignity** that anchors the viewer’s gaze instantly.\n\nReady to lock in absolute, unshakeable order?",
            keyIdeasCount: 4,
            durationText: "1-2 min",
            mechanics: [
                GridMechanic(
                    id: "sym_mech_1",
                    title: "The Central Axis",
                    readingTime: "1 min",
                    headline: "Go ahead, center your subject.\nBut make it absolutely perfect.",
                    bodyContent: "When you look through your viewfinder, forget about the off-center rules for a moment. Imagine a sharp, singular line slicing your frame exactly down the middle.\n\n• **The Centered Trap:** Plonking an object vaguely in the middle looks like an accident. If your alignment is off by even a few pixels, the human eye instantly flags the flaw, creating visual discomfort.\n\n• **The Pro Commitment:** Commit fully to the geometry. Lock your primary subject dead-center along the vertical axis, forcing both halves of the canvas to balance each other out with mathematical authority.",
                    imageAsset: "mock_sym_axis"
                ),
                GridMechanic(
                    id: "sym_mech_2",
                    title: "How to Use It",
                    readingTime: "1 min",
                    headline: "The magic splits right down the geometric center.",
                    bodyContent: "The line where the left and right halves mirror each other is your **Power Spine**. Unlike off-center compositions that make the eyes dart around, symmetry instantly freezes the gaze right in the middle, creating an immediate sense of weight, dignity, and absolute stillness.\n\nHuman intuition naturally loves balance. By treating your screen like a literal mirror, you turn a simple layout into a powerful, authoritative statement. What happens on the left must structurally echo what happens on the right.",
                    imageAsset: nil,
                    layoutStyle: .textCentered
                ),
                GridMechanic(
                    id: "sym_mech_3",
                    title: "When to Deploy The Rule",
                    readingTime: "1 min",
                    headline: "Different scenarios demand absolute stability. Choose your alignments carefully before clicking the shutter.",
                    bodyContent: "**ARCHITECTURE & MONUMENTS** — Perfect for grand cathedrals, symmetrical corridors, or minimalist facades. Let the structural leading lines converge dead-center to evoke a sense of scale, power, and permanence.\n\n**REFLECTIONS & WATER** — When shooting over completely still lakes, glass windows, or puddles. Lock the horizon line across the horizontal center to create a mesmerizing, parallel world.\n\n**MINIMALIST SINGLE SUBJECTS** — Use this when a lone subject stands against a clean canvas. Centering isolates the object entirely, transforming it into an undeniable focal point.",
                    imageAsset: nil
                )
            ],
            breakdown: PhotographicBreakdown(
                headline: "Why does this shot work? Let's dissect the composition layer by layer.",
                imageAsset: "image_7c58aa",
                photographer: "dimas daffa",
                layers: [
                    CompositionLayer(title: "The Central Flagpole", description: "acts as a rigid vertical axis cutting straight through the frame, anchor-weighting the entire visual right down the middle line."),
                    CompositionLayer(title: "The Organic Billow", description: "of the red-and-white flag breaks up the stiff geometric symmetry with natural movement, preventing the center composition from feeling too artificial or static."),
                    CompositionLayer(title: "The Heavy Negative Space", description: "of the overcast sky eliminates all surrounding background noise, completely forcing the viewer’s eye to lock onto the color contrast and symbolic presence of the subject.")
                ]
            )
        )
    ]
}
