package handler

import (
	"context"
	lookupv1 "github.com/halooid/backend/lookup-service/gen/go/lookup/v1"
	"github.com/halooid/backend/lookup-service/internal/service"
)

type LookupHandler struct {
	lookupv1.UnimplementedLookupServiceServer
	service *service.LookupService
}

func NewLookupHandler(service *service.LookupService) *LookupHandler {
	return &LookupHandler{service: service}
}

func (h *LookupHandler) GetLookupValues(ctx context.Context, req *lookupv1.GetLookupValuesRequest) (*lookupv1.GetLookupValuesResponse, error) {
	values, err := h.service.GetLookupValues(ctx, req.LookupKey)
	if err != nil {
		return nil, err
	}

	protoValues := make([]*lookupv1.LookupValue, len(values))
	for i, v := range values {
		metadataStr := ""
		if v.Metadata.Valid {
			metadataStr = string(v.Metadata.RawMessage)
		}

		protoValues[i] = &lookupv1.LookupValue{
			Id:       v.ID.String(),
			Code:     v.Code,
			Name:     v.Name,
			Metadata: metadataStr,
		}
	}

	return &lookupv1.GetLookupValuesResponse{
		Values: protoValues,
	}, nil
}
