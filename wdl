# description

# install

# docs

# spec
https://github.com/openwdl/wdl/blob/master/versions/1.0/SPEC.md

# config

# validation
womtool
wdldoc
miniwdl
tibanna ?
toil?


# versioning
warp: https://broadinstitute.github.io/warp/docs/About_WARP/VersionAndReleasePipelines/
terra: https://support.terra.bio/hc/en-us/articles/360037484111-How-does-pipeline-versioning-work-
docker: https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008316
gatk:
openwdl:
jaws: https://jaws-docs.readthedocs.io/en/latest/Intro/best_practices.html

# best practices
- use only docker
- use only sha digest to id containers
- include checker workflow (test w known output + digest)
- include 'String pipeline_version = "A.B.C"
-* A: major = changes in output, scientific meaning
-* B. minor = add files but no changes in scientific output / meaning
-* C. minor = patches only
- include changelog
- include contact info / author
- include link to repo
- DOI
- WDL digest + container digest ... = unit of reproducibility for pipeline version
https://broadinstitute.github.io/warp/docs/About_WARP/BestPractices


# wdl checker: DeepMicrobes: taxonomic classification for metagenomics with deep learning
	https://github.com/chanzuckerberg/miniwdl (pip) # installed by vscode ~/Library/Python/3.7/bin/miniwdl

# wdl validation
	cromwell::womtool
	miniwdl (pip)
	wdldoc (pip)
	tibanna? (pip)
	wdl2cwl (pip)

# wdl create docs
- https://github.com/biowdl/wdl-aid
	- wdldoc

# wdl repos
terra: https://app.terra.bio/#workspaces?tab=featured
topmed: https://github.com/DataBiosphere/topmed-workflows/blob/master/aligner/functional-equivalence-wdl/FunctionalEquivalence.wdl
biowdl: https://github.com/biowdl (~/Repos/Other/biowdl)
containers: https://dockstore.org/search?_type=workflow&descriptorType=wdl&searchMode=files
skylab: https://github.com/broadinstitute/warp/tree/develop/pipelines/skylab
openwdl:
warp:
gatk:

# wdl spec:
https://github.com/openwdl/wdl/blob/master/versions/development/SPEC.md

# singularity :
https://gatkforums.broadinstitute.org/wdl/discussion/11897/support-for-singularity

# validate / extract
cat  biowdl/tasks/unicycler.wdl  | comby -color -stdin  -match-only 'version 1.0 task :[t] { :[input] { :[input_body] }  :[cmd] { :[cmd_body] }  :[output] { :[out_body] } }'  '' > /tmp/x.wdl
- fix newlines
wdldoc /tmp/x.wdl
#womtool validate /tmp/x.wdl
"${JAVA_HOME}/bin/java"  -jar "/usr/local/Cellar/cromwell/84/libexec/womtool.jar" "$@" validate /tmp/x.wdl

# Whitespace, Strings, Identifiers, Constants spec (1.0)
ws = (0x20 | 0x9 | 0xD | 0xA)+
$identifier = [a-zA-Z][a-zA-Z0-9_]+
$string = "([^\\\"\n]|\\[\\"\'nrbtfav\?]|\\[0-7]{1,3}|\\x[0-9a-fA-F]+|\\[uU]([0-9a-fA-F]{4})([0-9a-fA-F]{4})?)*"
$string = '([^\\\'\n]|\\[\\"\'nrbtfav\?]|\\[0-7]{1,3}|\\x[0-9a-fA-F]+|\\[uU]([0-9a-fA-F]{4})([0-9a-fA-F]{4})?)*'
$boolean = 'true' | 'false'
$integer = [1-9][0-9]*|0[xX][0-9a-fA-F]+|0[0-7]*
$float = (([0-9]+)?\.([0-9]+)|[0-9]+\.|[0-9]+)([eE][-+]?[0-9]+)?
##
$string can accept the following between single or double-quotes:
Any character not in set: \\, " (or ' for single-quoted string), \n
An escape sequence starting with \\, followed by one of the following characters: \\, ", ', [nrbtfav], ?
An escape sequence starting with \\, followed by 1 to 3 digits of value 0 through 7 inclusive. This specifies an octal escape code.
An escape sequence starting with \\x, followed by hexadecimal characters 0-9a-fA-F. This specifies a hexidecimal escape code.
An escape sequence starting with \\u or \\U followed by either 4 or 8 hexadecimal characters 0-9a-fA-F. This specifies a unicode code point

# Types spec (1.0)
All inputs and outputs must be typed. The following primitive types exist in WDL:
Int i = 0                  # An integer value
Float f = 27.3             # A floating point number
Boolean b = true           # A boolean true/false
String s = "hello, world"  # A string value
File f = "path/to/file"    # A file
the following compound types can be constructed, parameterized by other types.
In the examples below P represents any of the primitive types above, and X and Y
represent any valid type (even nested compound types):
Array[X] xs = [x1, x2, x3]                    # An array of Xs
Map[P,Y] p_to_y = { p1: y1, p2: y2, p3: y3 }  # A map from Ps to Ys
Pair[X,Y] x_and_y = (x, y)                    # A pair of one X and one Y
Object o = { "field1": f1, "field2": f2 }     # Object keys are always `String`s
Some examples of types:
File
Array[File]
Pair[Int, Array[String]]
Map[String, String]
Types can also have a postfix quantifier (either ? or +):
? means that the value is optional. It can only be used in calls or functions that accept optional values.
+ can only be applied to Array types, and it signifies that the array is required to be non-empty.
For more details on the postfix quantifiers, see the section on Optional Parameters & Type Constraints

# Custom Types
WDL provides the ability to define custom compound types called Structs. Structs are defined directly in the WDL and are usable like any other type. For more information on their usage, see the section on Structs
Fully Qualified Names & Namespaced Identifiers
$fully_qualified_name = $identifier ('.' $identifier)*
$namespaced_identifier = $identifier ('.' $identifier)*
A fully qualified name is the unique identifier of any particular call or call input or output. For example:

# Expressions  spec 1.0
Expressions
$expression = '(' $expression ')'
$expression = $expression '.' $expression
$expression = $expression '[' $expression ']'
$expression = $expression '(' ($expression (',' $expression)*)? ')'
$expression = '!' $expression
$expression = '+' $expression
$expression = '-' $expression
$expression = if $expression then $expression else $expression
$expression = $expression '*' $expression
$expression = $expression '%' $expression
$expression = $expression '/' $expression
$expression = $expression '+' $expression
$expression = $expression '-' $expression
$expression = $expression '<' $expression
$expression = $expression '=<' $expression
$expression = $expression '>' $expression
$expression = $expression '>=' $expression
$expression = $expression '==' $expression
$expression = $expression '!=' $expression
$expression = $expression '&&' $expression
$expression = $expression '||' $expression
$expression = '{' ($expression ':' $expression)* '}'
$expression = '[' $expression* ']'
$expression = $string | $integer | $float | $boolean | $identifier

# Member Access
The syntax x.y refers to member access. x must be an object or task in a workflow. A Task can be thought of as an object where the attributes are the outputs of the task.

# Pair Indexing
Given a Pair x, the left and right elements of that type can be accessed using the syntax x.left and x.right.

# Function Calls
Function calls, in the form of func(p1, p2, p3, ...), are either standard library functions or engine-defined functions.
In this current iteration of the spec, users cannot define their own functions.

# Array Literals
Arrays values can be specified using Python-like syntax, as follows:
Array[String] a = ["a", "b", "c"]
Array[Int] b = [0,1,2]

# Map Literals
Maps values can be specified using a similar Python-like sytntax:
Map[Int, Int] = {1: 10, 2: 11}
Map[String, Int] = {"a": 1, "b": 2}

#Object Literals
Object literals are specified similarly to maps, but require an object keyword immediately before the {:
Object f = object {
  a: 10,
  b: 11
}
The object keyword allows the field keys to be specified as identifiers, rather than String literals (eg a: rather than "a":).

# Document
$document = ($import | $task | $workflow)+
$document is the root of the parse tree and it consists of one or more import statement, task, or workflow definition

# Import Statements
A WDL file may contain import statements to include WDL code from other sources
$import = 'import' $ws+ $string ($ws+ 'as' $ws+ $identifier)?#

#Task Definition
A task is a declarative construct with a focus on constructing a command from a template. The command specification is interpreted in an engine and backend agnostic way. The command is a UNIX bash command line which will be run (ideally in a Docker image).
Tasks explicitly define their inputs and outputs which is essential for building dependencies between tasks.
To declare a task, use task name { ... }. Inside the curly braces are the following sections:

# Task Sections
The task may have the following component sections:
An input section (required if the task will have inputs)
Non-input declarations (as many as needed, optional)
A command section (required)
A runtime section (optional)
An output section (required if the task will have outputs)
A meta section (optional)
A parameter_meta section (optional)

#Parameter Metadata Section
$parameter_meta = 'parameter_meta' $ws* '{' ($ws* $parameter_meta_kv $ws*)* '}'
$parameter_meta_kv = $identifier $ws* ':' $ws* $meta_value
$meta_value = $string | $number | $boolean | 'null' | $meta_object | $meta_array
$meta_object = '{}' | '{' $parameter_meta_kv (, $parameter_meta_kv)* '}'
$meta_array = '[]' |  '[' $meta_value (, $meta_value)* ']'
This purely optional section contains key/value pairs where the keys are names of parameters and the values are JSON like expressions that describe those parameters. The engine can ignore this section, with no loss of correctness. The extra information can be used, for example, to generate a user interface.

#Metadata Section
$meta = 'meta' $ws* '{' ($ws* $meta_kv $ws*)* '}'
$meta_kv = $identifier $ws* '=' $ws* $meta_value
This purely optional section contains key/value pairs for any additional meta data that should be stored with the task. For example, author, contact email, or engine authorization policies.

# Command

# Workflow Elements
A workflow may have the following elements:
An input section (required if the workflow is to have inputs)
Intermediate declarations (as many as needed, optional)
Calls to tasks or subworkflows (as many as needed, optional)
Scatter blocks (as many as needed, optional)
If blocks (as many as needed, optional)
An output section (required if the workflow is to have outputs)
A meta section (optional)
A parameter_meta section (optional)

# Call
Call Statement
$call = 'call' $ws* $namespaced_identifier $ws+ ('as' $identifier)? $ws* $call_body?
$call_body = '{' $ws* $inputs? $ws* '}'
$inputs = 'input' $ws* ':' $ws* $variable_mappings
$variable_mappings = $variable_mapping_kv (',' $variable_mapping_kv)*
$variable_mapping_kv = $identifier $ws* '=' $ws* $expression
A workflow may call other tasks/workflows via the call keyword. The $namespaced_identifier is the reference to which task to run. Most commonly, it's simply the name of a task (see examples below), but it can also use . as a namespace resolver.
  See the section on Fully Qualified Names & Namespaced Identifiers for details about how the $namespaced_identifier ought to be interpreted
  All call statements must be uniquely identifiable. By default, the call's unique identifier is the task name (e.g. call foo would be referenced by name foo). However, if one were to call foo twice in a workflow, each subsequent call statement will need to alias itself to a unique name using the as clause: call foo as bar.
  A call statement may reference a workflow too (e.g. call other_workflow). In this case, the $inputs section specifies a subset of the workflow's inputs and must specify fully qualified names

# Scatter
$scatter = 'scatter' $ws* '(' $ws* $scatter_iteration_statment $ws*  ')' $ws* $scatter_body
$scatter_iteration_statment = $identifier $ws* 'in' $ws* $expression
$scatter_body = '{' $ws* $workflow_element* $ws* '}'
A "scatter" clause defines that everything in the body ($scatter_body) can be run in parallel. The clause in parentheses ($scatter_iteration_statement) declares which collection to scatter over and what to call each element.
	The $scatter_iteration_statement has two parts: the "item" and the "collection". For example, scatter(x in y) would define x as the item, and y as the collection. The item is always an identifier, while the collection is an expression that MUST evaluate to an Array type. The item will represent each item in that expression. For example, if y evaluated to an Array[String] then x would be a String.
  The $scatter_body defines a set of scopes that will execute in the context of this scatter block.
  For example, if $expression is an array of integers of size 3, then the body of the scatter clause can be executed 3-times in parallel. $identifier would refer to each integer in the array.

# Output
#
# Structs
#
# Namespaces
Import statements can be used to pull in tasks/workflows from other locations as well as to create namespaces. In the simplest case, an import statement adds the tasks/workflows that are imported into the specified namespace

# Scope
Scopes are defined as:

workflow {...} blocks
call blocks
while(expr) {...} blocks
if(expr) {...} blocks
scatter(x in y) {...} blocks
Inside of any scope, variables may be declared. The variables declared in that scope are visible to any sub-scope, recursively.

# Optional Parameters & Type Constraints
Types can be optionally suffixed with a ? or + in certain cases.

? means that the parameter is optional. A user does not need to specify a value for the parameter in order to satisfy all the inputs to the workflow.
+ applies only to Array types and it represents a constraint that the Array value must containe one-or-more elements.

# Standard library
# File stdout()
	File stderr()
Array[String] read_lines(String|File)
Array[Array[String]] read_tsv(String|File)
Map[String, String] read_map(String|File)
Object read_object(String|File)
Array[Object] read_objects(String|File)
mixed read_json(String|File)
Int read_int(String|File)
String read_string(String|File)
Float read_float(String|File)
Boolean read_boolean(String|File)
File write_lines(Array[String])
File write_tsv(Array[Array[String]])
File write_map(Map[String, String])
File write_object(Object)
File write_objects(Array[Object])
File write_json(mixed)
Float size(File, [String])
String sub(String, String, String)
Array[Int] range(Int)
Array[Array[X]] transpose(Array[Array[X]])
Array[Pair[X,Y]] zip(Array[X], Array[Y])
Array[Pair[X,Y]] cross(Array[X], Array[Y])
Integer length(Array[X])
Array[X] flatten(Array[Array[X]])
Array[String] prefix(String, Array[X])
X select_first(Array[X?])
 Array[X] select_all(Array[X?])
Boolean defined(X?)
String basename(String)
Int floor(Float), Int ceil(Float) and Int round(Float)
\\

# Serialization

# find tasks
rg '^tasks \w+ \{'
semgrep --vim -o /tmp/biowdl.tasks --verbose --exclude="*.py" -l generic -e 'task $T { ... }' .
