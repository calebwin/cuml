/*
 * Copyright (c) 2018-2020, NVIDIA CORPORATION.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <common/cumlHandle.hpp>
#include <cuda_utils.cuh>
#include <distance/distance.cuh>
#include <score/scores.cuh>

namespace ML {
namespace Metrics {

/**
        * @brief Compute the trustworthiness score
        * @input param X: Data in original dimension
        * @input param X_embedded: Data in target dimension (embedding)
        * @input param n: Number of samples
        * @input param m: Number of features in high/original dimension
        * @input param d: Number of features in low/embedded dimension
        * @input param n_neighbors: Number of neighbors considered by trustworthiness score
        * @input tparam distance_type: Distance type to consider
        * @return Trustworthiness score
        */
template <typename math_t, ML::Distance::DistanceType distance_type>
double trustworthiness_score(const raft::handle_t& h, math_t* X,
                             math_t* X_embedded, int n, int m, int d,
                             int n_neighbors, int batchSize) {
  cudaStream_t stream = h.get_stream();
  auto d_alloc = h.get_device_allocator();

  return MLCommon::Score::trustworthiness_score<math_t, distance_type>(
    X, X_embedded, n, m, d, n_neighbors, d_alloc, stream, batchSize);
}

template double
trustworthiness_score<float, ML::Distance::DistanceType::EucUnexpandedL2Sqrt>(
  const raft::handle_t& h, float* X, float* X_embedded, int n, int m, int d,
  int n_neighbors, int batchSize);

};  //end namespace Metrics
};  //end namespace ML
