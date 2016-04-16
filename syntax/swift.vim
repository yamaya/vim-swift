" Language:    Swift<https://developer.apple.com/swift/>
" Maintainer:  toyama satoshi <toyamarinyon@gmail.com>
" URL:         http://github.com/toyamarinyon/vim-swift
" License:     GPL

" Bail if our syntax is already loaded.
if exists('b:current_syntax') && b:current_syntax == 'swift'
  finish
endif
let s:cpo_save = &cpo
set cpo&vim

" Comments
" Shebang
syn match swiftShebang "\v#!.*$" display

" Comment contained keywords
syn keyword swiftTodos display contained TODO XXX FIXME NOTE
syn keyword swiftMarker display contained MARK

" Literals
" Strings
syn region swiftString start=/"/ skip=/\\"/ end=/"/ contains=swiftInterpolatedWrapper
syn region swiftInterpolatedWrapper start="\v\\\(\s*" end="\v\s*\)" contained containedin=swiftString contains=swiftInterpolatedString
syn match swiftInterpolatedString "\v\w+(\(\))?" contained containedin=swiftInterpolatedWrapper

" Numbers
syn match swiftNumber display "\v<$\@!\d+>"
syn match swiftNumber display "\v<\d+\.\d+>"
syn match swiftNumber display "\v<\d*\.?\d+([Ee]-?)?\d+>"
syn match swiftNumber display "\v<0x\x+([Pp]-?)?\x+>"
syn match swiftNumber display "\v<0b[01]+>"
syn match swiftNumber display "\v<0o\o+>"

syn match swiftKeywords display "\v\$\d+>"

" BOOLs
syn keyword swiftBoolean display true false

" Operators
"syn match swiftOperator display "\v\~"
"syn match swiftOperator display "\v\s+!"
"syn match swiftOperator display "\v\%"
"syn match swiftOperator display "\v\^"
"syn match swiftOperator display "\v\&"
"syn match swiftOperator display "\v\*"
"syn match swiftOperator display "\v-"
"syn match swiftOperator display "\v\+"
"syn match swiftOperator display "\v\="
"syn match swiftOperator display "\v\|"
"syn match swiftOperator display "\v\/"
"syn match swiftOperator display "\v\."
"syn match swiftOperator display "\v\<"
"syn match swiftOperator display "\v\>"
"syn match swiftOperator display "\v\?\?"

"syn match swiftOperator "\s!=\_s"ms=s+1,me=e-1 display conceal cchar=≠
"syn match swiftOperator "\s->\_s"ms=s+1,me=e-1 display conceal cchar=→
"syn match swiftOperator "\sas?\?\_s"ms=s+1,me=e-1 display

" Keywords {{{
syn keyword swiftKeywords
      \ break
      \ case
      \ class
      \ continue
      \ convenience
      \ default
      \ deinit
      \ didSet
      \ do
			\ catch
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
      \ guard
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
			\ try
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
syn match swiftKeywords display 'as[?!]'

syn match swiftAttributes display "\v\@(assignment|autoclosure|availability|exported|IBAction|IBDesignable|IBInspectable|IBOutlet|noreturn|NSApplicationMain|NSCopying|NSManaged|objc|UIApplicationMain|testable)"
"syn region swiftTypeWrapper start="\v:\s*" end="\v[^\w]" contains=swiftString,swiftBoolean,swiftNumber,swiftType,swiftGenericsWrapper transparent oneline
"syn region swiftGenericsWrapper start="\v\<" end="\v\>" contains=swiftType transparent oneline
" syn region swiftLiteralWrapper start="\v\=\s*" skip="\v[^\[\]]\(\)" end="\v(\[\]|\(\))" contains=swiftType transparent oneline
"syn region swiftReturnWrapper start="\v-\>\s*" end="\v(\{|$)" contains=swiftType transparent oneline
"syn match swiftType "\v\u\w*" contained containedin=swiftGenericsWrapper,swiftTypeWrapper,swiftLiteralWrapper,swiftGenericsWrapper

syn keyword swiftType Bool String Int Int8 Int16 Int32 Int64 Character Void Double Float
syn keyword swiftImports import

" Comment patterns
syn match swiftComment display "\v\/\/.*$" contains=swiftTodos,swiftMarker,@Spell oneline
syn region swiftComment start="/\*" end="\*/" contains=swiftTodos,swiftMarker,swiftComment,@Spell fold

" Standard Protocol
syn keyword swiftProtocol Indexable SequenceType

" Standard Class
syn keyword swiftStruct Any AnyObject Optional
syn keyword swiftStruct Array ArraySlice CollectionOfOne ContiguousArray Dictionary DictionaryLiteral EmptyCollection FlattenBidirectionalCollection FlattenCollection LazyCollection Range Repeat ReverseCollection Set Slice UnsafeBufferPointer
syn keyword swiftStruct AnyGenerator AnySequence EnumerateGenerator EnumerateSequence FlattenGenerator FlattenSequence GeneratorOfOne GeneratorSequence IndexingGenerator JoinSequence LazyFilterGenerator

" Standard Function
syn keyword swiftFunction print dump
syn keyword swiftFunction objc_sync_enter objc_sync_exit

" Conditional Compile Directive
syn region swiftPreCondit start="^\s*#\(if\|ifdef\|ifndef\|elseif\)\>" skip="\\$" end="$" keepend contains=swiftComment,swiftPreConditFunction,swiftPreConditConstant
syn match  swiftPreConditMatch display "^\s*#\(else\|endif\)\>"
"syn cluster swiftCppOutInGroup contains=swiftCppInIf,swiftCppInElse,swiftCppInElse2,swiftCppOutIf,swiftCppOutIf2,swiftCppOutElse,swiftCppInSkip,swiftCppOutSkip
syn region swiftOutWrapper start="^\s*#if\s\+false\s*\($\|//\|/\*\|&\)" end=".\@=\|$" contains=swiftOutIf,swiftOutElse,@NoSpell fold
syn region swiftOutIf contained start="false" matchgroup=swiftOutWrapper end="^\s*#endif\>" contains=swiftOutIf2,swiftOutElse
syn region swiftOutIf2 contained matchgroup=swiftOutWrapper start="false" end="^\s*#\(else\>\|elseif\s\+\(false\s*\($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=swiftOutSkip,@Spell fold
syn region swiftOutElse contained matchgroup=swiftOutWrapper start="^\s*#\(else\|elseif\)" end="^\s*#endif\>"me=s-1 contains=TOP,swiftPreCondit
syn region swiftInWrapper start="^\s*#if\s\+true\s*\($\|//\|/\*\||\)" end=".\@=\|$" contains=swiftInIf,swiftInElse fold
syn region swiftInIf contained matchgroup=swiftInWrapper start="\d\+" end="^\s*#endif\>" contains=TOP,swiftPreCondit
syn region swiftInElse contained start="^\s*#\(else\>\|elseif\s\+\(true\s*\($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=swiftInIf contains=swiftInElse2
syn region swiftInElse2 contained matchgroup=swiftInWrapper start="^\s*#\(else\|elseif\)\([^/]\|/[^/*]\)*" end="^\s*#endif\>"me=s-1 contains=swiftOutSkip,@Spell
syn region swiftOutSkip contained start="^\s*#\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*#endif\>" contains=swiftOutSkip
syn region swiftInSkip contained matchgroup=swiftInWrapper start="^\s*#\(if\s\+\(\d\+\s*\($\|//\|/\*\||\|&\)\)\@!\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*#endif\>" containedin=swiftOutElse,swiftInIf,swiftInSkip contains=TOP
syn keyword swiftPreConditFunction os arch
syn keyword swiftPreConditConstant OSX iOS x86_64 arm arm64 i386

" conceal
hi! default link Conceal Normal
syn match swiftKeywords display '->' conceal cchar=→

" Set highlights
hi default link swiftTodos Todo
hi default link swiftShebang Comment
hi default link swiftComment Comment
hi default link swiftMarker Comment

hi default link swiftString String
hi default link swiftInterpolatedWrapper Delimiter
hi default link swiftNumber Number
hi default link swiftBoolean Boolean
hi default link swiftConstant Constant

hi default link swiftOperator Operator
hi default link swiftKeywords Keyword
hi default link swiftAttributes PreProc
hi default link swiftFunction Function
hi default link swiftType Type
hi default link swiftProtocol Tag
hi default link swiftStruct Type
hi default link swiftClass Type
hi default link swiftImports Include

hi default link swiftPreCondit			PreCondit
hi default link swiftPreConditFunction	Function
hi default link swiftPreConditConstant	Constant
hi default link swiftPreConditMatch	PreCondit
hi default link swiftInWrapper			PreCondit
hi default link swiftOutWrapper			PreCondit
hi default link swiftOutIf2					Comment
hi default link swiftOutSkip				Comment
hi default link swiftInElse2				Comment

let b:current_syntax = 'swift'

let &cpo = s:cpo_save
unlet s:cpo_save
