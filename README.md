# Collective-phenomena
Understanding how simple interaction rules can produce complex, emergent motion. Inspired by the Couzin metric model, I coded a full MATLAB simulation that reproduces polarisation, clustering and milling. Along the way I compared metric vs topological neighbourhood concepts, explored Artificial Swarm Intelligence.
1 Motivation and Background
 Collective motion fascinates me because order appears without any leader. By re-implementing
 the metric Couzin model I forced myself to juggle non-linear dynamics, geometry and efficient
 code—all while reading modern critiques that prefer topological interactions. My aim was both
 technical (vectorised MATLAB practice) and conceptual (grasping emergence).
 
 2 Key Concepts from my Reading
 
 I'm covering key concepts that cover several pillars of computational ethology:
 
 • Three-zone rule set—repulsion, alignment, attraction.
 
 • Phase transitions from disorder to order driven by local rules (Vicsek vs. Reynolds vs.
 Couzin).
 
 • Active inference and future-state maximisation as alternatives to vectorial “social
 forces”.
 
 • Metric vs. Topological neighbourhoods: metric triggers by fixed radius, whereas
 topological uses a fixed number of nearest neighbours— biologically argued to be superior.
 
 • Implementation stack: rules for movement, force balance, synchrony vs. asynchrony,
 stochastic noise, boundary conditions and network topology (see Fig. 1).
 
 3 Reference: Implementation Blocks
 <img width="677" height="366" alt="image" src="https://github.com/user-attachments/assets/65f4c6be-6e8c-4e08-bb66-3cc7fe4b8b1c" />

 Figure 1: Extract from a lecture slide summarising the building blocks of an agent-based model.
 The two columns on the left list behaviour rules (e.g. alignment, attraction, wall interaction)
 while the right column lists network-topology choices and dynamical flags. I used this as my
 personal checklist when coding.
 
 
4 Metric vs. Topological Models
 Most early flocking models—including my Couzin implementation—are metric: an agent reacts
 to anyone within a distance r. This is simple but breaks down at variable densities: crowded
 regions overload perception, sparse areas isolate individuals.
 
 Topological models instead process a fixed number (e.g. 7) of nearest neighbours regardless
 of distance, matching starling data and offering robustness. Recent ABM work therefore mixes
 or fully replaces metric radii with nearest-neighbour sets. My code remains metric because it
 maps directly to the classical three-zone diagram and was ideal for first-principles learning.
 
 4.1 agent_simulation.m
 
 Purpose: generate positions and headings for N agents over T steps. Each loop cycle executes
 the Couzin rule hierarchy, limited field of view, bounded turning rate and reflective wall.
 Design choices
 
 • Vectorised distance matrix for O(N2) neighbour lookup.
 
 • Sector-test with acos to enforce visual angle.
 
 • Separate boolean masks for repulsion, orientation, attraction zones.
 
 • Optional Gaussian noise err to study robustness.

  4.2 compute_metrics.m
  
 ComputespolarisationP(t)andclusteringC(t) thensaves the twoPNGs. Network
 connectivity employs MATLAB’s graph/conn computilities.

  4.3 animate_agents.m
  
 Renders a quiver plot per frame and can export GIF or MP4. I tweaked colours and head-size
 for visibility

  4.4 demo_analysis.m
  
 Convenience wrapper tying everything together.

  5 Global Order Parameters
  
 Interpretation Polarisation approaching one indicates almost every heading is aligned; clus
tering near one confirms all agents share a single connected component.

 6 Results
 
 Qualitatively, agents begin in a swirling mill, undergo intermittent fragmentation, and finally
 lock into a travelling band at t ≈ 120s. 
 Quantitatively,the result shows both P and C saturating.
 Milling emerges when attraction outweighs orientation yet vision is wide—a parameter slice
 noted in my notes.
 
 7 Applications and Lessons Learned
 
 Beyond satisfying curiosity, this mini-project sharpened my MATLAB vectorisation skills and
 grounded my reading on Artificial Swarm Intelligence (ASI)—algorithmic swarms solving tasks
 from mapping to search-and-rescue.
 
 8 Future Directions
 
 1. Topological rewrite: replace distance mask with k-nearest list.
 2. Active inference overlay: integrate predictive coding cost.
 3. 3-D environment: lift agents into a spherical tank
