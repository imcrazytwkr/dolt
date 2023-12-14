// Copyright 2022-2023 Dolthub, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Code generated by the FlatBuffers compiler. DO NOT EDIT.

package serial

import (
	flatbuffers "github.com/dolthub/flatbuffers/v23/go"
)

type CommitClosure struct {
	_tab flatbuffers.Table
}

func InitCommitClosureRoot(o *CommitClosure, buf []byte, offset flatbuffers.UOffsetT) error {
	n := flatbuffers.GetUOffsetT(buf[offset:])
	return o.Init(buf, n+offset)
}

func TryGetRootAsCommitClosure(buf []byte, offset flatbuffers.UOffsetT) (*CommitClosure, error) {
	x := &CommitClosure{}
	return x, InitCommitClosureRoot(x, buf, offset)
}

func TryGetSizePrefixedRootAsCommitClosure(buf []byte, offset flatbuffers.UOffsetT) (*CommitClosure, error) {
	x := &CommitClosure{}
	return x, InitCommitClosureRoot(x, buf, offset+flatbuffers.SizeUint32)
}

func (rcv *CommitClosure) Init(buf []byte, i flatbuffers.UOffsetT) error {
	rcv._tab.Bytes = buf
	rcv._tab.Pos = i
	if CommitClosureNumFields < rcv.Table().NumFields() {
		return flatbuffers.ErrTableHasUnknownFields
	}
	return nil
}

func (rcv *CommitClosure) Table() flatbuffers.Table {
	return rcv._tab
}

func (rcv *CommitClosure) KeyItems(j int) byte {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(4))
	if o != 0 {
		a := rcv._tab.Vector(o)
		return rcv._tab.GetByte(a + flatbuffers.UOffsetT(j*1))
	}
	return 0
}

func (rcv *CommitClosure) KeyItemsLength() int {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(4))
	if o != 0 {
		return rcv._tab.VectorLen(o)
	}
	return 0
}

func (rcv *CommitClosure) KeyItemsBytes() []byte {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(4))
	if o != 0 {
		return rcv._tab.ByteVector(o + rcv._tab.Pos)
	}
	return nil
}

func (rcv *CommitClosure) MutateKeyItems(j int, n byte) bool {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(4))
	if o != 0 {
		a := rcv._tab.Vector(o)
		return rcv._tab.MutateByte(a+flatbuffers.UOffsetT(j*1), n)
	}
	return false
}

func (rcv *CommitClosure) AddressArray(j int) byte {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(6))
	if o != 0 {
		a := rcv._tab.Vector(o)
		return rcv._tab.GetByte(a + flatbuffers.UOffsetT(j*1))
	}
	return 0
}

func (rcv *CommitClosure) AddressArrayLength() int {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(6))
	if o != 0 {
		return rcv._tab.VectorLen(o)
	}
	return 0
}

func (rcv *CommitClosure) AddressArrayBytes() []byte {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(6))
	if o != 0 {
		return rcv._tab.ByteVector(o + rcv._tab.Pos)
	}
	return nil
}

func (rcv *CommitClosure) MutateAddressArray(j int, n byte) bool {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(6))
	if o != 0 {
		a := rcv._tab.Vector(o)
		return rcv._tab.MutateByte(a+flatbuffers.UOffsetT(j*1), n)
	}
	return false
}

func (rcv *CommitClosure) SubtreeCounts(j int) byte {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(8))
	if o != 0 {
		a := rcv._tab.Vector(o)
		return rcv._tab.GetByte(a + flatbuffers.UOffsetT(j*1))
	}
	return 0
}

func (rcv *CommitClosure) SubtreeCountsLength() int {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(8))
	if o != 0 {
		return rcv._tab.VectorLen(o)
	}
	return 0
}

func (rcv *CommitClosure) SubtreeCountsBytes() []byte {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(8))
	if o != 0 {
		return rcv._tab.ByteVector(o + rcv._tab.Pos)
	}
	return nil
}

func (rcv *CommitClosure) MutateSubtreeCounts(j int, n byte) bool {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(8))
	if o != 0 {
		a := rcv._tab.Vector(o)
		return rcv._tab.MutateByte(a+flatbuffers.UOffsetT(j*1), n)
	}
	return false
}

func (rcv *CommitClosure) TreeCount() uint64 {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(10))
	if o != 0 {
		return rcv._tab.GetUint64(o + rcv._tab.Pos)
	}
	return 0
}

func (rcv *CommitClosure) MutateTreeCount(n uint64) bool {
	return rcv._tab.MutateUint64Slot(10, n)
}

func (rcv *CommitClosure) TreeLevel() byte {
	o := flatbuffers.UOffsetT(rcv._tab.Offset(12))
	if o != 0 {
		return rcv._tab.GetByte(o + rcv._tab.Pos)
	}
	return 0
}

func (rcv *CommitClosure) MutateTreeLevel(n byte) bool {
	return rcv._tab.MutateByteSlot(12, n)
}

const CommitClosureNumFields = 5

func CommitClosureStart(builder *flatbuffers.Builder) {
	builder.StartObject(CommitClosureNumFields)
}
func CommitClosureAddKeyItems(builder *flatbuffers.Builder, keyItems flatbuffers.UOffsetT) {
	builder.PrependUOffsetTSlot(0, flatbuffers.UOffsetT(keyItems), 0)
}
func CommitClosureStartKeyItemsVector(builder *flatbuffers.Builder, numElems int) flatbuffers.UOffsetT {
	return builder.StartVector(1, numElems, 1)
}
func CommitClosureAddAddressArray(builder *flatbuffers.Builder, addressArray flatbuffers.UOffsetT) {
	builder.PrependUOffsetTSlot(1, flatbuffers.UOffsetT(addressArray), 0)
}
func CommitClosureStartAddressArrayVector(builder *flatbuffers.Builder, numElems int) flatbuffers.UOffsetT {
	return builder.StartVector(1, numElems, 1)
}
func CommitClosureAddSubtreeCounts(builder *flatbuffers.Builder, subtreeCounts flatbuffers.UOffsetT) {
	builder.PrependUOffsetTSlot(2, flatbuffers.UOffsetT(subtreeCounts), 0)
}
func CommitClosureStartSubtreeCountsVector(builder *flatbuffers.Builder, numElems int) flatbuffers.UOffsetT {
	return builder.StartVector(1, numElems, 1)
}
func CommitClosureAddTreeCount(builder *flatbuffers.Builder, treeCount uint64) {
	builder.PrependUint64Slot(3, treeCount, 0)
}
func CommitClosureAddTreeLevel(builder *flatbuffers.Builder, treeLevel byte) {
	builder.PrependByteSlot(4, treeLevel, 0)
}
func CommitClosureEnd(builder *flatbuffers.Builder) flatbuffers.UOffsetT {
	return builder.EndObject()
}
