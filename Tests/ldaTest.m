function tests = ldaTest
tests = functiontests(localfunctions);
end

function test3(testCase)
[T,S,P] = run_task_list('test_lda3'); 
% actSolution = 
actSolution = quadraticSolver(1,-3,2);
expSolution = [2,1];
verifyEqual(test3,actSolution,expSolution);
end

