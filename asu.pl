/*---------------------------*/
/* Basic drawing Functions  */
/*-------------------------*/
drawSymbol(_, 0).
drawSymbol(Symbol, N) :- 
    N > 0, 
    write(Symbol), 
    N1 is N - 1, 
    drawSymbol(Symbol, N1).

drawHorizontalLine(_, 0) :- nl.
drawHorizontalLine(Symbol, N) :- drawSymbol(Symbol, N).

/* _ shows unused variables and ! ensures that recursion stops */
drawVerticalLinesWithSpace(_, 0, _) :- !.
drawVerticalLinesWithSpace(Symbol, Height, Width) :- 
    Height > 0,
    write(Symbol),
    drawSymbol(' ', Width - 2),
    write(Symbol),
    nl,
    Height1 is Height - 1,
    drawVerticalLinesWithSpace(Symbol, Height1, Width).

  /*---------*/
 /* draw A */
/*-------*/
drawA(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber) :-
    ColumnNumber >= TextWidth, !.

/* Left-most and right-most columns with stars */
drawA(TextWidth, _TextHeight, FontSize, _CurrentLine, ColumnNumber) :-
    (
        (ColumnNumber >= 0, ColumnNumber < FontSize);
        (ColumnNumber >= FontSize * 2, ColumnNumber < TextWidth)
    ),
    drawSymbol('*', FontSize),
    NextColumn is ColumnNumber + FontSize,
    drawA(TextWidth, _TextHeight, FontSize, _CurrentLine, NextColumn).

/* Middle segment with stars */
drawA(TextWidth, _TextHeight, FontSize, CurrentLine, ColumnNumber) :-
    (ColumnNumber >= FontSize, ColumnNumber < FontSize * 2),
    (
        (CurrentLine >= 0, CurrentLine < FontSize);
        (CurrentLine >= FontSize * 2, CurrentLine < FontSize * 3)
    ),
    drawSymbol('*', FontSize),
    NextColumn is ColumnNumber + FontSize,
    drawA(TextWidth, _TextHeight, FontSize, CurrentLine, NextColumn).

/* Middle segment with spaces */
drawA(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber) :-
    (ColumnNumber >= FontSize, ColumnNumber < FontSize * 2),
    (
        (CurrentLine >= FontSize, CurrentLine < 2 * FontSize);
        (CurrentLine >= FontSize * 3, CurrentLine < TextHeight)
    ),
    drawSymbol(' ', FontSize),
    NextColumn is ColumnNumber + FontSize,
    drawA(TextWidth, TextHeight, FontSize, CurrentLine, NextColumn).

  /*---------*/
 /* draw S */
/*-------*/
/* The letter 'S' has stars in:
   - Top (0 <= line < FontSize)
   - Middle (2 * FontSize <= line < 3 * FontSize)
   - Bottom (4 * FontSize <= line < 5 * FontSize)
   And vertical stars:
   - Left for 0–2*FontSize
   - Right for 2*FontSize–5*FontSize
*/
drawS(TextWidth, _TextHeight, _FontSize, _CurrentLine, ColumnNumber) :-
    ColumnNumber >= TextWidth, !.

/* Top, Middle, Bottom horizontal segments (full stars) */
drawS(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber) :-
    (
        (CurrentLine >= 0, CurrentLine < FontSize);
        (CurrentLine >= 2 * FontSize, CurrentLine < 3 * FontSize);
        (CurrentLine >= 4 * FontSize, CurrentLine < TextHeight)
    ),
    drawSymbol('*', FontSize),
    NextColumn is ColumnNumber + FontSize,
    drawS(TextWidth, TextHeight, FontSize, CurrentLine, NextColumn).

/* Left vertical segment (upper half) */
drawS(TextWidth, _TextHeight, FontSize, CurrentLine, ColumnNumber) :-
    (CurrentLine >= FontSize, CurrentLine < 2 * FontSize),
    (ColumnNumber >= 0, ColumnNumber < FontSize),
    drawSymbol('*', FontSize),
    NextColumn is ColumnNumber + FontSize,
    drawS(TextWidth, _TextHeight, FontSize, CurrentLine, NextColumn).

/* Lower half (Right Vertical Segment) */
drawS(TextWidth, _TextHeight, FontSize, CurrentLine, ColumnNumber) :-
    (CurrentLine >= 3 * FontSize, CurrentLine < 4 * FontSize),
    (ColumnNumber >= 2 * FontSize, ColumnNumber < TextWidth),
    drawSymbol('*', FontSize),
    NextColumn is ColumnNumber + FontSize,
    drawS(TextWidth, _TextHeight, FontSize, CurrentLine, NextColumn).

/*------------------*/
/* Any other spaces */
/*------------------*/
drawS(TextWidth, _TextHeight, FontSize, _CurrentLine, ColumnNumber) :-
    drawSymbol(' ', FontSize),
    NextColumn is ColumnNumber + FontSize,
    drawS(TextWidth, _TextHeight, FontSize, _CurrentLine, NextColumn).

/*----------------*/
/* Proper Spacing */
/*----------------*/
draw(_LeftRightMargin, _SpaceBetweenCharacters, _FontSize, CurrentLine, _TextWidth, TextHeight) :-
    CurrentLine >= TextHeight, !.

draw(LeftRightMargin, SpaceBetweenCharacters, FontSize, CurrentLine, TextWidth, TextHeight) :-
    CurrentLine < TextHeight,
    ColumnNumber is 0,
    write('|'),
    drawSymbol(' ', LeftRightMargin),
    drawA(TextWidth, TextHeight, FontSize, CurrentLine, ColumnNumber),
    drawSymbol(' ', SpaceBetweenCharacters),
    drawS(TextWidth, TextHeight, FontSize, CurrentLine, 0),
    drawSymbol(' ', LeftRightMargin),
    write('|'), nl,
    NextLine is CurrentLine + 1,
    draw(LeftRightMargin, SpaceBetweenCharacters, FontSize, NextLine, TextWidth, TextHeight).

/*---------------------------------------*/
/* Initiating variables for drawing ASU */
/*-------------------------------------*/
drawVerticalLinesWithCharacters(LeftRightMargin, _BottomTopMargin, SpaceBetweenCharacters, FontSize) :-
    CurrentLine is 0,
    TextWidth is FontSize * 3,
    TextHeight is FontSize * 5,
    draw(LeftRightMargin, SpaceBetweenCharacters, FontSize, CurrentLine, TextWidth, TextHeight).

/*-----------------------------*/
/* Main Method that draws ASU */
/*---------------------------*/
asu(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize) :-
    integer(LeftRightMargin), integer(BottomTopMargin),
    integer(SpaceBetweenCharacters), integer(FontSize),

    Width is (LeftRightMargin * 2 + SpaceBetweenCharacters * 2 + FontSize * 3 * 3 + 2),
    Height is (BottomTopMargin * 2 + FontSize * 5),

    /* top horizontal line of the box */
    drawHorizontalLine('-', Width), nl,

    /* the empty space in the top */
    drawVerticalLinesWithSpace('|', BottomTopMargin, Width),

    /* the actual text */
    drawVerticalLinesWithCharacters(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize),

    /* the empty space in the bottom */
    drawVerticalLinesWithSpace('|', BottomTopMargin, Width),

    /* bottom horizontal line of the box */
    drawHorizontalLine('-', Width).
