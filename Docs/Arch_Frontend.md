# SNode : Syntax Nodes

These are intended to be the nodes that closest correlate to use expression in the langauge.  
They do not have clear semantic intent and that needs to be resolved before constructing the full program model.
Thats done by translating SNodes to [RSNodes]().  
These can either be generated via the text pipeline (Text Editor, Lexer and TParser) or it may be generated directly by a SNode editor.

|  |  |
| :---- | :---- |
| Type       | Type of SNode |
| Attributes | Addtional type information reguarding the context of this node. |
| Span       | If the node was generated from text, this indicates the line and column range in the text the node was generated from. |
| Parent     | Parent SNode |
| Data       | May either be corresponding SNodes or a text string |


# SParser : Syntax Node Parser

Parses SNodes and generates an ast tree of RSNodes which may be processed by the Program Model generator.

# RSNode : Resolved Symbol Nodes

Nodes which all contextual ambiguity for symbols provided from an SNode tree are resolved.

|  |  |
| :---- | :---- |
| Type       | Type of RSNode |
| Attributes | Addtional type information reguarding the context of this node. |
| SNodes     | SNodes that the RSNode was derived from
| Parent     | Parent RSNode |
| Data       | May either be corresponding RSNodes or a String |

# Text Pipeline

## TEditor

Used to edit langauge text in a traditional way. Used as a sub-module of the VSEditor.

## Lexer

Produces lexial tokens compatiable with the TParser.
Only used with text related pipeline.

# TParser : Text Parser

Parses the tokens to form an ast tree of SNodes. Only used with text related pipeline.

# Visual Pipeline

## VSEditor

Used to edit an SNode ast tree using VSNodes and TEditor UI nodes as the interface.

## VSNode : Visual Syntax Node

These are a GUI visual representation of an set of SNodes.

![img](https://i.imgur.com/NczGVdy.png)

|  |  |
| :---- | :---- |
| Content  | A valid stack of SNodes |
| HB       | Horizontal box optionally created if the SNode stack has a context body |
| VINdent  | Visual representation of the identation used to indication the statements are the body of the content stack. |
| Indent   | Variable spacer to vary indentation width |
| VB       | Vertical box to visually hold the list of child VSNodes |
| Children | An array of child VSNodes |

VSNodes are mainly intended to render the langauge in a visually appealing way, with more opportunity to produce advanced visualizations and contextual helpers based on the program model inferred by an IDE.

Editing a VSNode is done either 2 ways : Either creating content stacks via a dialog menu or by swiching a VSNode's content box or a selected set of content boxes to TEditor mode where they will be translated back down to properly formatted text string for editing.  
When user finishes editing the node or nodes the SNodes and VSNodes will be regenerated in place.