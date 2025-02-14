; RUN: llc < %s -asm-verbose=false | FileCheck %s

; This test depends on branching support, which is not yet checked in.
; XFAIL: *

; Test that phis are lowered.

target datalayout = "e-p:32:32-i64:64-v128:8:128-n32:64-S128"
target triple = "wasm32-unknown-unknown"

; Basic phi triangle.

; CHECK-LABEL: test0
; CHECK: (setlocal [[REG:@.*]] (argument 0))
; CHECK: (setlocal [[REG]] (sdiv [[REG]] {{.*}}))
; CHECK: (return [[REG]])
define i32 @test0(i32 %p) {
entry:
  %t = icmp slt i32 %p, 0
  br i1 %t, label %true, label %done
true:
  %a = sdiv i32 %p, 3
  br label %done
done:
  %s = phi i32 [ %a, %true ], [ %p, %entry ]
  ret i32 %s
}

; Swap phis.

; CHECK-LABEL: test1
; CHECK: BB0_1:
; CHECK: (setlocal [[REG0:@.*]] [[REG1:@.*]])
; CHECK: (setlocal [[REG1]] [[REG2:@.*]])
; CHECK: (setlocal [[REG2]] [[REG0]])
define i32 @test1(i32 %n) {
entry:
  br label %loop

loop:
  %a = phi i32 [ 0, %entry ], [ %b, %loop ]
  %b = phi i32 [ 1, %entry ], [ %a, %loop ]
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]

  %i.next = add i32 %i, 1
  %t = icmp slt i32 %i.next, %n
  br i1 %t, label %loop, label %exit

exit:
  ret i32 %a
}
