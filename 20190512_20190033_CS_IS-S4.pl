:-[students_courses].


% Start Task1 %

member(X,[X|_]).
member(X,[_|T]):-
    member(X,T).
notMember(X,List):-
    not(member(X,List)).

append([],List):-
    append([],List,List).
append(List,List):-
    append([],List,List).
append([],List,List).
append([H|T],List,[H|List2]):-
    append(T,List,List2).


studentsInCourse(Course,List):-
    studentsInCourse(Course,[],List).

studentsInCourse(Course,TmpList,List):-
    student(ID,Course,Grade),
    %append([[ID,Grade]],[],StudentList),
    notMember([ID,Grade],TmpList),
    !,
    append([[ID,Grade]],TmpList,NewTmpList),
    studentsInCourse(Course,NewTmpList,List).

studentsInCourse(_,List,List).

% End Task1 %


%  Start Task2 %

getSize([],0).
getSize([_|T],N):-
    getSize(T,N1),
    N is N1+1.


numStudents(Course,Num):-
    studentsInCourse(Course,List),
    getSize(List,Num).

% End Task2 %



% Start Task3 %
%
getGradeList(ID,List):-
    getGradeList(ID,[],List).
getGradeList(ID,TmpList,List):-
    student(ID,_,Grade),
    notMember(Grade,TmpList),
    !,
    append([Grade],TmpList,NewTmpList),
    getGradeList(ID,NewTmpList,List).

getGradeList(_,List,List).

getMaxElem([X],X).
getMaxElem([X,Y|R],Max):-
    getMaxElem([Y|R],MaxR),
    max(X,MaxR,Max),!.
max(X,Y,X):-
    X >= Y.
max(X,Y,Y):-
    X < Y.

maxStudentGrade(ID,MaxGrade):-
   getGradeList(ID,List),!,
   getMaxElem(List,MaxGrade),!.

% End Task3 %




% Start Task4 %

toConvert(0,zero).
toConvert(1,one).
toConvert(2,two).
toConvert(3,three).
toConvert(4,four).
toConvert(5,five).
toConvert(6,six).
toConvert(7,seven).
toConvert(8,eight).
toConvert(9,nine).

convertFunction([],[]).
convertFunction([X|Tail],[T|Z]):-
    toConvert(X,T),
    convertFunction(Tail,Z).

splitFunction(Num,List):- % one digit grade
    H1 is mod(Num,10),
    H2 is Num-H1,
    H2=:=0 ->
    append([],[H1],List).

splitFunction(Num,List):- % two digits grade
     H1 is mod(Num,10),
     H2 is Num-H1,
     H3 is H2/10,
     H3<10, H3>0 ->
            append([H3],[H1],List).

splitFunction(Num,List):- % 100 grade
     Num=:=100,
     append([0],[0],List1),
     append([1],List1,List).

gradeInWords(ID,Course,DigitsWords):-
    student(ID,Course,Grade),
    splitFunction(Grade,List),!,
    convertFunction(List,DigitsWords).

% End Task4 %



% Start Task5 %

remainingCourses(ID,Target,Courses):-
    remainingCourses(ID,Target,[],Courses).

remainingCourses(ID,Target,TmpList,Courses):-
    prerequisite(Course1,Target),
    student(ID,Course1,Grade),
    Grade>=50,
    append(TmpList,[],Courses),!.

remainingCourses(ID,Target,_,Courses):-
    prerequisite(Course1,Target),
    student(ID,Course1,Grade),
    Grade<50 ->
         remainingCourses(ID,Course1,Courses,Courses),!.

remainingCourses(ID,Target,TmpList,Courses):-
    prerequisite(Course1,Target),
    not(student(ID,Course1,_)),
    notMember(Course1,TmpList),
    !,
    append([Course1],TmpList,NewTmpList),
    remainingCourses(ID,Course1,NewTmpList,Courses).


remainingCourses(ID,Course1,Courses,Courses):-
    not(student(ID,Course1,_)) ->
         Courses=false,!.

% End Task5 %

