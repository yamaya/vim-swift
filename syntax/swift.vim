" Language:    Swift<https://developer.apple.com/swift/>
" Maintainer:  toyama satoshi <toyamarinyon@gmail.com>
" URL:         http://github.com/toyamarinyon/vim-swift
" License:     GPL

" Bail if our syntax is already loaded.
if exists('b:current_syntax') && b:current_syntax == 'swift'
  finish
endif

" Comments
" Shebang
syntax match swiftShebang "\v#!.*$"

" Comment contained keywords
syntax keyword swiftTodos contained TODO XXX FIXME NOTE
syntax keyword swiftMarker contained MARK

" Literals
" Strings
syntax region swiftString start=/"/ skip=/\\"/ end=/"/ contains=swiftInterpolatedWrapper
syntax region swiftInterpolatedWrapper start="\v\\\(\s*" end="\v\s*\)" contained containedin=swiftString contains=swiftInterpolatedString
syntax match swiftInterpolatedString "\v\w+(\(\))?" contained containedin=swiftInterpolatedWrapper

" Numbers
syntax match swiftNumber "\v<\d+>"
syntax match swiftNumber "\v<\d+\.\d+>"
syntax match swiftNumber "\v<\d*\.?\d+([Ee]-?)?\d+>"
syntax match swiftNumber "\v<0x\x+([Pp]-?)?\x+>"
syntax match swiftNumber "\v<0b[01]+>"
syntax match swiftNumber "\v<0o\o+>"

" BOOLs
syntax keyword swiftBoolean true false

" Operators
syntax match swiftOperator "\v\~"
syntax match swiftOperator "\v\s+!"
syntax match swiftOperator "\v\%"
syntax match swiftOperator "\v\^"
syntax match swiftOperator "\v\&"
syntax match swiftOperator "\v\*"
syntax match swiftOperator "\v-"
syntax match swiftOperator "\v\+"
syntax match swiftOperator "\v\="
syntax match swiftOperator "\v\|"
syntax match swiftOperator "\v\/"
syntax match swiftOperator "\v\."
syntax match swiftOperator "\v\<"
syntax match swiftOperator "\v\>"
syntax match swiftOperator "\v\?\?"

" Methods/Functions
syntax match swiftMethod "\(\.\)\@<=\w\+\((\)\@="

" Keywords {{{
syntax keyword swiftKeywords
      \ as
      \ break
      \ case
      \ class
      \ continue
      \ convenience
      \ default
      \ deinit
      \ didSet
      \ do
      \ dynamic
      \ else
			\ enum
      \ extension
      \ fallthrough
      \ final
      \ for
      \ func
      \ get
      \ if
      \ import
      \ in
      \ infix
      \ init
      \ inout
      \ internal
      \ is
      \ lazy
      \ let
      \ mutating
      \ nil
      \ operator
      \ optional
      \ override
      \ postfix
      \ prefix
      \ private
      \ protocol
      \ public
      \ required
      \ return
      \ self
      \ set
      \ static
			\ struct
      \ subscript
      \ super
      \ switch
      \ typealias
      \ unowned
      \ unowned(safe)
      \ unowned(unsafe)
      \ var
      \ weak
      \ where
      \ while
      \ willSet
" }}}

syntax match swiftAttributes "\v\@(assignment|autoclosure|availability|exported|IBAction|IBDesignable|IBInspectable|IBOutlet|noreturn|NSApplicationMain|NSCopying|NSManaged|objc|UIApplicationMain)"
"syntax region swiftTypeWrapper start="\v:\s*" end="\v[^\w]" contains=swiftString,swiftBoolean,swiftNumber,swiftType,swiftGenericsWrapper transparent oneline
"syntax region swiftGenericsWrapper start="\v\<" end="\v\>" contains=swiftType transparent oneline
" syntax region swiftLiteralWrapper start="\v\=\s*" skip="\v[^\[\]]\(\)" end="\v(\[\]|\(\))" contains=swiftType transparent oneline
"syntax region swiftReturnWrapper start="\v-\>\s*" end="\v(\{|$)" contains=swiftType transparent oneline
"syntax match swiftType "\v\u\w*" contained containedin=swiftGenericsWrapper,swiftTypeWrapper,swiftLiteralWrapper,swiftGenericsWrapper

syntax keyword swiftType Bool AnyObject String Array Dictionary
syntax keyword swiftImports import

" Comment patterns
syntax match swiftComment "\v\/\/.*$" contains=swiftTodos,swiftMarker,@Spell oneline
syntax region swiftComment start="/\*" end="\*/" contains=swiftTodos,swiftMarker,swiftComment,@Spell fold

" Standard Class
syntax keyword swiftClass Any AnyObject 

" Conditional Compile Directive
syn region	swiftPreCondit	start="^\s*#\s*\(if\|ifdef\|ifndef\|elseif\)\>" skip="\\$" end="$" keepend contains=swiftComment,swiftCommentL
syn match	  swiftPreConditMatch display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
syn cluster	swfitOutInGroup	contains=swfitInIf,swfitInElse,swfitInElse2,swfitOutIf,swfitOutIf2,swfitOutElse,swfitInSkip,swfitOutSkip
syn region	swfitOutWrapper	start="^\s*\(%:\|#\)\s*if\s\+0\+\s*\($\|//\|/\*\|&\)" end=".\@=\|$" contains=swfitOutIf,swfitOutElse,@NoSpell fold
syn region	swfitOutIf	contained start="0\+" matchgroup=swfitOutWrapper end="^\s*\(%:\|#\)\s*endif\>" contains=swfitOutIf2,swfitOutElse
syn region	swfitOutIf2	contained matchgroup=swfitOutWrapper start="0\+" end="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0\+\s*\($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=cSpaceError,swfitOutSkip,@Spell
syn region	swfitOutElse	contained matchgroup=swfitOutWrapper start="^\s*\(%:\|#\)\s*\(else\|elif\)" end="^\s*\(%:\|#\)\s*endif\>"me=s-1 contains=TOP,cPreCondit
syn region	swfitInWrapper	start="^\s*\(%:\|#\)\s*if\s\+0*[1-9]\d*\s*\($\|//\|/\*\||\)" end=".\@=\|$" contains=swfitInIf,swfitInElse fold
syn region	swfitInIf	contained matchgroup=swfitInWrapper start="\d\+" end="^\s*\(%:\|#\)\s*endif\>" contains=TOP,cPreCondit
syn region	swfitInElse	contained start="^\s*\(%:\|#\)\s*\(else\>\|elif\s\+\(0*[1-9]\d*\s*\($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=swfitInIf contains=swfitInElse2 fold
syn region	swfitInElse2	contained matchgroup=swfitInWrapper start="^\s*\(%:\|#\)\s*\(else\|elif\)\([^/]\|/[^/*]\)*" end="^\s*\(%:\|#\)\s*endif\>"me=s-1 contains=cSpaceError,swfitOutSkip,@Spell
syn region	swfitOutSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=cSpaceError,swfitOutSkip
syn region	swfitInSkip	contained matchgroup=swfitInWrapper start="^\s*\(%:\|#\)\s*\(if\s\+\(\d\+\s*\($\|//\|/\*\||\|&\)\)\@!\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" containedin=swfitOutElse,swfitInIf,swfitInSkip contains=TOP,cPreProc


" Set highlights
highlight default link swiftTodos Todo
highlight default link swiftShebang Comment
highlight default link swiftComment Comment
highlight default link swiftMarker Comment

highlight default link swiftString String
highlight default link swiftInterpolatedWrapper Delimiter
highlight default link swiftNumber Number
highlight default link swiftBoolean Boolean

highlight default link swiftOperator Operator
highlight default link swiftKeywords Keyword
highlight default link swiftAttributes PreProc
"highlight default link swiftStructure Structure
highlight default link swiftType Type
highlight default link swiftImports Include
highlight default link swiftMethod Function

highlight default link swiftPreCondit				PreCondit
highlight default link swiftPreConditMatch	PreCondit

let b:current_syntax = 'swift'
