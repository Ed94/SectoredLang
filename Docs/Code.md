## Code is an interface for information.

In the context of specifiying machine execution, programming langauges are used as medium for interfacing with tools to generate machine execution.

Almost all programming langauges are designed around the original design of written human languages. Text is built out of textual symbol primitives (unicode is the modern standard), and they are stored in file handled by tooling to then be generated eventually to the intended targets machine specific ISA encoding for execution.

This interface works well enough to get us by quite well. Similar to how the mathematical syntax and language developed for that discipline has also gotten by quite well to this day but they are reaching their limits with this medium and so are programmers with programming langauges.

The issue with mathematics lies in the how difficult enormous proofs are to maintain or verify. Even with formal notation and syntax to completely rigorize the langauge, a human can only keep track of so much complexity. The same can be said with our programming langauges and their toolchain for the end goal. Make a machine effectively do what we want.

Currently the solution for mathematics is type theory and its use to implement automated proof checkers, and programs like mathematica, etc. To help aid in manging complex and dynamic introspection of mathematical constructs.

For programming, we so far have mitigated tooling using the following around our langauges:
* AI
* Benchmarking
* CodeCompletion
* Debuggers
* Linters
* Profiling
* Search
* SyntaxHighlighting
* etc

While the ecosystem for these different tools may be glued together into a single interface (such as an IDE), they have no proper interchange of the same information they all are deriving from the medium the user directly handles: Text.

Text becomes the bottleneck for providing a streamlined expereince.  
Whats more is that there are still notable grivances frome either missing tools or problems with the medium itself:  
* Text can only render and organize information so well.
* Text is slower to process in the backend than alternative formats.
* We cannot easily generate or render to the user intermediate code or instrinsicts.
* We cannot easily assess costs of different factors for development:
  * Langauge feature interpretation or compliation time
  * Metaprogramming generation time or size
  * Symbol contextual pollution
  * Linking time
  * Readability
  * Executable size
  * Runtime cache footprint or cycle count
  
### Text can only render and organize information so well:
Text is not the best way to display or communicate written information. This should have been clear with all the research that has been done in the fields of UX/UI or Graphic Design. The way the symbols are formatted and oriented across negative spaces heavily impacts how quicikly information can be processed. Keeping the most complex language for specification of execution for the most complex machines made by humans constrained to raw text rendering is a major design failure.

### Text is slower to process in the backend than alternative formats:
Text is biggest constraint when it comes to processing source code. While it may the simplest format for human specification that can be boostrapped for processing by a program, that simplicty and reliablity comes at the cost of toolchain peformance. The [Dion Format](https://dion.systems/dion_format.html) and [Metadesk](https://dion.systems/metadesk.html) seem to be viable alternative for the future.

### Generating or rendering user intermediate code or intrinsicts:
The only relaible way to this is if the compiler or linker has some flags to dump an intermediate blob of a translation unit before its further processed. These files are cumbersome and are not ideal to traverse. Nor are they seamless to view and make updates to the working source while comparing this output.

### Accessing Cost:  
These still mainly require a programmer to keep in mind. 
Producing an unecessary burden of mental overhead when contemplating basic design decisions. This leads us to make langauges and solutions that sacrifice performance when they may not have needed.