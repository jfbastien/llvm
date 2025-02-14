; RUN: opt -S -lowerbitsets < %s | FileCheck %s

; Tests that non-string metadata nodes may be used as bitset identifiers.

target datalayout = "e-p:32:32"

; CHECK: @[[BNAME:.*]] = private constant { [2 x i32] }
; CHECK: @[[ANAME:.*]] = private constant { i32 }

@a = constant i32 1
@b = constant [2 x i32] [i32 2, i32 3]

!0 = !{!2, i32* @a, i32 0}
!1 = !{!3, [2 x i32]* @b, i32 0}
!2 = distinct !{}
!3 = distinct !{}

!llvm.bitsets = !{ !0, !1 }

declare i1 @llvm.bitset.test(i8* %ptr, metadata %bitset) nounwind readnone

; CHECK-LABEL: @foo
define i1 @foo(i8* %p) {
  ; CHECK: icmp eq i32 {{.*}}, ptrtoint ({ i32 }* @[[ANAME]] to i32)
  %x = call i1 @llvm.bitset.test(i8* %p, metadata !2)
  ret i1 %x
}

; CHECK-LABEL: @bar
define i1 @bar(i8* %p) {
  ; CHECK: icmp eq i32 {{.*}}, ptrtoint ({ [2 x i32] }* @[[BNAME]] to i32)
  %x = call i1 @llvm.bitset.test(i8* %p, metadata !3)
  ret i1 %x
}
