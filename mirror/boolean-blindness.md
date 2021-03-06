# **Boolean Blindness**

## *Original*

(Authored by “*Abstract Type*”. Hosted on their blog, at <https://existentialtype.wordpress.com/2011/03/15/boolean-blindness/>.)

I hate Booleans!  But isn’t everything “just bits”?  Aren’t computers built from gates?  And aren’t gates just the logical connectives?  How can a Computer Scientist possibly hate Booleans?

Fritz Henglein recently pointed out to me that the world of theoretical Computer Science is divided into two camps, which I’ll call the logicians (who are concerned with languages and semantics) and the combinatorialists (who are concerned with algorithms and complexity).  The logicians love to prove that programs work properly, the combinatorialists love to count how many steps a program takes to run.  Yet, curiously, the logicians hate the Booleans, and love abstractions such as trees or streams, whereas the combinatorialists love bits, and hate abstraction!  (Or so it often seems; allow me my rhetorical devices.)

My point is this.  Booleans are just one, singularly (or, perhaps, binarily) boring, type of data.  A Boolean, b, is either true, or false; that’s it.  There is no information carried by a Boolean beyond its value, and that’s the rub.  As Conor McBride puts it, to make use of a Boolean you have to know its provenance so that you can know what it means.

Booleans are almost invariably (in the CS literature and textbooks) confused with propositions, which express an assertion, or make a claim.  For a proposition, p, to be true means that it has a proof; there is a communicable, rational argument for why p is the case.  For a proposition, p, to be false means that it has a refutation; there is a counterexample that shows why p is not the case.

The language here is delicate.  The judgement that a proposition, p, is true is not the same as saying that p is equal to true, nor is the judgement that p is false the same as saying that p is equal to false!  In fact, it makes no sense to even ask the question, is p equal to true, for the former is a proposition (assertion), whereas the latter is a Boolean (data value); they are of different type.

In classical mathematics, where computability is not a concern, it is possible to conflate the notions of Booleans and propositions, so that there are only two propositions in the world, true and false.  The role of a proof is to show that a given proposition is (equal to) one of these two cases.  This is well and good, provided that you’re not interested in computing whether something is true or false.  As soon as you are, you must own up to a distinction between a general proposition, whose truth cannot be decided, and a Boolean, which can be computed one way or the other.  But then, as was mentioned earlier, we must link it up with a proposition expressing what the Boolean means, which is to specify its provenance.  And as soon as we do that, we realize that Booleans have no special status, and are usually a poor choice of data structure anyway because they lead to a condition that Dan Licata calls Boolean blindness.

A good example is the equality test, `e=e’`, of type bool.  As previously discussed, this seemingly innocent function presents serious complications, particularly in abstract languages with a rich type structure.  It also illustrates the standard confusion between a proposition and a Boolean.  As the type suggests, the equality test operation is a function that returns either true or false, according to whether its arguments are equal or not (in a sense determined by their type).  Although the notation invites confusion, the expression e=e’ is not a proposition stating that `e` and `e’` are equal!  It is, rather, a piece of data of one of two forms, either true or false.  The equality test is a function that happens to have the property that if it returns true, then its arguments are equal (an associated equality proposition is true), and if it returns false, then its arguments are not equal (an associated equality proposition is false), and, moreover, is ensured to return either true or false for any inputs.  This may seem like a hair-splitting distinction, but it is not!  For consider, first of all, that the equality test may have been written with a different syntax, maybe `e==e’`, or `(equal? e e’)`, or any number of other notations.  This makes clear, I hope, that the connection between the function and the associated proposition must be explicitly made by some other means; the function and the proposition are different things.  More interestingly, the same functionality can be expressed different ways.  For example, for partially ordered types we may write `e<=e’` and also `e’<=e`, or similar, satisfying the same specification as the innocent little “equals sign” function.  The connection is looser still here, and still looser in numerous other variations that you can spin for yourself.

What harm is there in making this confusion?  Perhaps the greatest harm is that it confuses a fundamental distinction, and this has all sorts of bad consequences.  For example, a student may reasonably ask, why is equality not defined for functions?  After all, in the proof I did the other day, I gave a carefully argument by structural induction that two functions are equal.  And then I turn around and claim that equality is not defined for functions!  What on earth am I talking about?  Well, if you draw the appropriate distinction, there is no issue.  Of course there is a well-defined concept of two functions being mathematically equal; it, in general, requires proof.  But there is no well-defined computable function that returns true iff two functions (on integers, say) are equal, and false otherwise.  Thus, = : (int->int) x (int->int) -> prop expresses equality, but = : (int->int)->(int->int)->bool cannot satisfy the specification just given.  Or, to put it another way, you cannot test equality of propositions!  (And rightly so.)

Another harm is the condition of Boolean blindness alluded to earlier.  Suppose that I evaluate the expression `e=e’` to test whether `e` and `e’` are equal.  I have in my hand a bit.  The bit itself has no intrinsic meaning; I must associate a provenance with that bit in order to give it meaning.  “This bit being true means that `e` and `e’` are equal, whereas this other bit being false means that some other two expressions are not equal.”  Keeping track of this information (or attempting to recover it using any number of program analysis techniques) is notoriously difficult.  The only thing you can do with a bit is to branch on it, and pretty soon you’re lost in a thicket of `if-the-else`’s, and you lose track of what’s what.  Evolve the program a little, and you’re soon out to sea, and find yourself in need of sat solvers to figure out what the hell is going on.

But this is yet another example of an iatrogenic disorder!  The problem is computing the bit in the first place.  Having done so, you have blinded yourself by reducing the information you have at hand to a bit, and then trying to recover that information later by remembering the provenance of that bit.  An illustrative example was considered in my article on equality:

    fun plus x y = if x=Z then y else S(plus (pred x) y)

Here we’ve crushed the information we have about x down to one bit, then branched on it, then were forced to recover the information we lost to justify the call to pred, which typically cannot recover the fact that its argument is non-zero and must check for it to be sure.  What a mess!  Instead, we should write

    fun plus x y = case x of Z => y | S(x’) => S(plus x’ y).

No Boolean necessary, and the code is improved as well!  In particular, we obtain the predecessor en passant, and have no need to keep track of the provenance of any bit.

As an exercise, convince yourself that the entire business of “null pointer analysis” is pointless, for exactly the same reasons!  There are few things more stupid in the world than code that compares a pointer for equality with null, then branches on the outcome, and then finds itself needing a sat solver or model checker to propagate the provenance of a boolean that should never have been computed in the first place!

## *Commentary*

Links:

* <https://www.reddit.com/r/programming/comments/gk2le/boolean_blindness_why_bool_isnt_good_enough/>

