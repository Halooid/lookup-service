package service

import (
	"context"
	"github.com/halooid/backend/lookup-service/internal/db"
)

type LookupService struct {
	queries db.Querier
}

func NewLookupService(queries db.Querier) *LookupService {
	return &LookupService{queries: queries}
}

func (s *LookupService) GetLookupValues(ctx context.Context, lookupKey string) ([]db.GetLookupValuesRow, error) {
	return s.queries.GetLookupValues(ctx, lookupKey)
}
